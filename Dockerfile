FROM ubuntu:20.04 as nchan-builder

RUN apt-get -y update
RUN apt-get -y install \
        curl ca-certificates build-essential zlib1g-dev \
        libpcre3-dev libhiredis-dev libssl-dev

## Install latest nchan from source code
RUN curl -L -O https://github.com/slact/nchan/archive/v1.2.7.tar.gz && \
    curl -L -O http://archive.ubuntu.com/ubuntu/pool/main/n/nginx/nginx_1.18.0.orig.tar.gz && \
    tar xf v1.2.7.tar.gz && tar xf nginx_1.18.0.orig.tar.gz && \
    cd nginx-1.18.0 && \
    ./configure --with-compat --add-dynamic-module=/nchan-1.2.7 && \
    make

## Install python demo package
FROM ubuntu:20.04 as py-builder

RUN apt-get -y update
RUN apt-get -y install \
        python3-setuptools python3-wheel python3-pip

ENV PYTHONUSERBASE=/srv/pub_sub_demo/
COPY . /src/
RUN pip3 install --user /src


## Runtime image
FROM ubuntu:20.04

RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        python3 nginx-light

COPY --from=nchan-builder /nginx-1.18.0/objs/ngx_nchan_module.so /usr/lib/nginx/modules/ngx_nchan_module.so
COPY --from=py-builder /srv/pub_sub_demo /srv/pub_sub_demo
COPY nginx.conf /etc/nginx/nginx.conf

ENV PYTHONUSERBASE=/srv/pub_sub_demo/
ENV FLASK_APP=pub_sub_demo.app
CMD nginx && $PYTHONUSERBASE/bin/flask run
