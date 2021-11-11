FROM debian:bullseye as py-builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update
RUN apt-get -y install \
        python3-setuptools python3-wheel python3-pip

ENV PYTHONUSERBASE=/srv/pub_sub_demo/
COPY . /src/
RUN pip3 install --user /src


## Runtime image
FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        python3 nginx-light libnginx-mod-nchan

COPY --from=py-builder /srv/pub_sub_demo /srv/pub_sub_demo
COPY nginx.conf /etc/nginx/nginx.conf

ENV PYTHONUSERBASE=/srv/pub_sub_demo/
ENV FLASK_APP=pub_sub_demo.app
CMD nginx && $PYTHONUSERBASE/bin/flask run
