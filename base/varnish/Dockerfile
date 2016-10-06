FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y automake \
					   autotools-dev \
					   libedit-dev \
					   libjemalloc-dev \
					   libncurses-dev \
					   libpcre3-dev \
					   libtool \
					   pkg-config \
					   python-docutils \
					   python-sphinx \
					   graphviz \
					   build-essential \
					   git

RUN git clone https://github.com/varnishcache/varnish-cache /tmp/varnish-cache

WORKDIR /tmp/varnish-cache

RUN ./autogen.sh
RUN ./configure
RUN make -j 8
RUN make install

RUN apt-get install -y libvarnish-dev

ADD start start

RUN chmod 0755 start

CMD ["./start"]
