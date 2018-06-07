FROM ubuntu:artful

RUN apt-get update && apt-get upgrade -fy && apt-get install -fy libssl-dev build-essential git

RUN git clone https://git.torproject.org/tor.git /tmp/tor

WORKDIR /tmp/tor

RUN apt-get install -fy autoconf libevent-dev

RUN ./autogen.sh && ./configure --disable-asciidoc
RUN make install -j 10

ENTRYPOINT ["tor"]

CMD []
