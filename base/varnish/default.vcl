vcl 4.0;

# PLEASE SEE NGINX CONFIGURATION FOR ARCHITECTURE:
# /etc/nginx/enabled-sites/mediawiki

# Varnish is deployed as a TLS-terminated caching
# proxy for nginx.

# set default backend if no server cluster specified
backend default {
    .host = "pagespeed";
#    .host = "ruleproxy";
    .port = "80";

    .connect_timeout = 10s;
    .first_byte_timeout = 60s;
    .between_bytes_timeout = 60s;
}

# access control list for "purge": open to only localhost and other local nodes
acl purge {
    "127.0.0.1";
    "2.2.0.0"/24;
}

# vcl_recv is called whenever a request is received 
sub vcl_recv {
    # Serve objects up to 2 minutes past their expiry if the backend
    # is slow to respond.
    #set req.grace = 120s;

    if (req.restarts == 0) {
        if (req.http.X-Forwarded-For) {
            set req.http.X-Forwarded-For = req.http.X-Forwarded-For + ", " + client.ip;
        } else {
            set req.http.X-Forwarded-For = client.ip;
        }
    }

    set req.backend_hint= default;

    # This uses the ACL action called "purge". Basically if a request to
    # PURGE the cache comes from anywhere other than localhost, ignore it.
    if (req.method == "PURGE") {
        if (!client.ip ~ purge) {
            return (synth(405, "Not allowed."));
        } else {
            return (purge);
        }
    }

    # Pass any requests that Varnish does not understand straight to the backend.
    if (req.method != "GET" && req.method != "HEAD" &&
        req.method != "PUT" && req.method != "POST" &&
        req.method != "TRACE" && req.method != "OPTIONS" &&
        req.method != "DELETE") {
        return (pipe);
    } /* Non-RFC2616 or CONNECT which is weird. */

    # Pass anything other than GET and HEAD directly.
    if (req.method != "GET" && req.method != "HEAD") {
        return (pass);
    }      /* We only deal with GET and HEAD by default */

    # Pass requests from logged-in users directly.
#    if (req.http.Authorization || req.http.Cookie) {
    if (req.http.Cookie ~ "mediawiki_pw__session") {
        return (pass);
    } /* Not cacheable by default */

    # Pass any requests with the "If-None-Match" header directly.
    if (req.http.If-None-Match) {
        return (pass);
    }

    # Force lookup if the request is a no-cache request from the client.
    if (req.http.Cache-Control ~ "no-cache") {
        ban(req.url);
    }

    # normalize Accept-Encoding to reduce vary
    if (req.http.Accept-Encoding) {
        if (req.http.User-Agent ~ "MSIE 6") {
            unset req.http.Accept-Encoding;
        } elsif (req.http.Accept-Encoding ~ "gzip") {
            set req.http.Accept-Encoding = "gzip";
        } elsif (req.http.Accept-Encoding ~ "deflate") {
            set req.http.Accept-Encoding = "deflate";
        } else {
           unset req.http.Accept-Encoding;
        }
    }

    return (hash);
}

sub vcl_pipe {
    # Note that only the first request to the backend will have
    # X-Forwarded-For set.  If you use X-Forwarded-For and want to
    # have it set for all requests, make sure to have:
    # set req.http.connection = "close";

    # This is otherwise not necessary if you do not do any request rewriting.

    set req.http.connection = "close";
}

# Called if the cache has a copy of the page.
sub vcl_hit {
    if (req.method == "PURGE") {
       ban(req.url);

       return (synth(200, "Purged"));
    }

    if (!obj.ttl > 0s) {
        return (pass);
    }
}

# Called if the cache does not have a copy of the page.
sub vcl_miss {
    if (req.method == "PURGE")  {
        return (synth(200, "Not in cache"));
    }
}

# Called after a document has been successfully retrieved from the backend.
sub vcl_backend_response {
    # set minimum timeouts to auto-discard stored objects
    set beresp.grace = 120s;

    if (!beresp.ttl > 0s) {
        set beresp.uncacheable = true;

        return (deliver);
    }

    if (beresp.http.Set-Cookie) {
        set beresp.uncacheable = true;

        return (deliver);
    }

    # disable due to mediawiki quirkiness

    #if (beresp.http.Cache-Control ~ "(private|no-cache|no-store)") {
    #    set beresp.uncacheable = true;
    #    return (deliver);
    #}

    if (beresp.http.Authorization && !beresp.http.Cache-Control ~ "public") {
        set beresp.uncacheable = true;
        return (deliver);
    }

    return (deliver);
}
