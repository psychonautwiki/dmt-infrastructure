FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -fy git cmake build-essential libssl-dev libtool automake

RUN git clone https://github.com/h2o/h2o.git /tmp/h2o

WORKDIR /tmp/h2o

RUN git clone https://github.com/tatsuhiro-t/wslay.git /tmp/h2o/wslay
RUN cd /tmp/h2o/wslay ; cmake . ; make install -j 8

RUN git clone https://github.com/libuv/libuv.git /tmp/h2o/libuv
RUN cd /tmp/h2o/libuv ; ./autogen.sh && ./configure && make install -j 8

RUN cmake -DWITH_BUNDLED_SSL=on .
RUN make -j 8 && make install

CMD h2o -c /h2o/h2o.conf
