FROM debian:bullseye as py-builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update
RUN apt-get -y install \
        python3-setuptools python3-wheel python3-pip

ENV PYTHONUSERBASE=/srv/pub_sub_demo/
COPY setup.py MANIFEST.in /src
COPY pub_sub_demo /src/pub_sub_demo
RUN pip3 install --user /src


## Runtime image
FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        python3 python3-setuptools nginx-light libnginx-mod-nchan

COPY --from=py-builder /srv/pub_sub_demo /srv/pub_sub_demo
COPY nginx.conf /etc/nginx/nginx.conf

ENV PYTHONUSERBASE=/srv/pub_sub_demo/
ENV FLASK_APP=pub_sub_demo:app
ENV PORT=5000
CMD nginx && $PYTHONUSERBASE/bin/gunicorn --log-level warning $FLASK_APP
