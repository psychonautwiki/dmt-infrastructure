FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get upgrade -fy
RUN apt-get install -y automake \
					   autotools-dev \
					   libedit-dev \
					   libjemalloc-dev \
					   libncurses-dev \
					   libpcre3-dev \
					   libtool \
					   pkg-config \
					   python3 \
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
RUN make install ; ldconfig

#RUN apt-get install -y libvarnish-dev
#RUN apt-get install -y libvarnishapi-dev

ADD start start

RUN chmod 0755 start

CMD ["./start"]
