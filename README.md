# demo nginx/nchan pub/sub service

Uses the [nchan nginx module](https://nchan.io/) <tt>[[github](https://github.com/slact/nchan)]</tt>.

The demo includes an nginx configuration that configures the nchan endpoints,
and a small python/flask web application that simulates a backend that authorizes the
publishers and subsribers. The python app, also servers a demo static web page (html/js/css)
that is both a publisher and subscriber.

## Quickstart

to run the demo:
```
docker build -t pub-sub-demo .
docker run -it --publish 8000:80 --rm pub-sub-demo
```

Open [http://localhost:8000](http://localhost:8000) in your browser.

## cli pub/sub

`curl` publisher:
```
curl -i \
    --header "Content-Type: application/json" \
    --data '{"message":"test 1"}' \
    http://localhost:8000/publish?topic=one

curl -i \
    --header "Content-Type: application/json" \
    --data '{"message":"test 2"}' \
    http://localhost:8000/publish?topic=one
```

`curl` subscriber (can subscribe to more than one topic):
```
curl -i \
    --header 'Accept: text/event-stream' \
    --header "Content-Type: application/json" \
    --get --data-urlencode 'payload={"topics":["one","two"]}' \
    http://localhost:8000/subscribe
```
