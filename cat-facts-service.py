import time
from flask import Flask
import requests
import json

CAT_FACTS_URL = 'https://cat-fact.herokuapp.com/facts/random?amount=1'

app = Flask(__name__)


# HTTP listener
@app.route('/api/v1/cat/facts', methods=['POST', 'GET'])
def catFacts():
    res = requests.get(CAT_FACTS_URL)
    if res.status_code == 200:
        return json.loads(res.text)
    else:
        return

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=8081)
