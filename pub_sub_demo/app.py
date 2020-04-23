from flask import Flask, request
import json

app = Flask(__name__)

### clients hit this directly
@app.route('/subscribe', methods=['GET'])
def subscribe():
    #raw_data = request.get_data()
    #payload = request.get_json()
    payload = json.loads(request.args.get('payload'))
    # really check signature here! (not in scope for demo)
    signature_ok = True

    if payload and signature_ok:
        topics = ','.join(payload['topics'])
        x_accel_redirect = f'/internal_sub/{topics}'
        headers = {
            'X-Accel-Redirect': x_accel_redirect,
            'X-Accel-Buffering': 'no'
        }
        print(f'Subscription accepted. X-Accel-Redirect: {x_accel_redirect}')
        return "it's ok", 200, headers

    return "not allowed", 403


### nchan calls this to authorize the publish operation
@app.route('/authorize_pub', methods=['POST'])
def pub():
    raw_data = request.get_data()
    payload = request.get_json()
    # really check signature here! (not in scope for demo)
    signature_ok = True
    if payload and signature_ok:

        # publish payload.message
        topic = request.headers['X-Channel-Id']
        print(f'Publish accepted. Topic: {topic}')
        return payload['message'], 200

    return 'message discarded', 204


@app.route('/')
def index():
    return app.send_static_file('index.html')
