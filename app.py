import time
from flask import Flask
import requests
import json

CAT_FACTS_URL = 'https://cat-fact.herokuapp.com/facts/random?amount=1'
DEFAULT_FACTS = {
    "Status": "No response from API",
    "DefaultFact": "Cats are cute"
}

app = Flask(__name__)


# HTTP listener
@app.route('/api/v1/cat/facts', methods=['POST', 'GET'])
def cat_facts():
    try:
        res = requests.get(CAT_FACTS_URL, timeout=5)
        if res.status_code == 200:
            return json.loads(res.text)
        else:
            return json.dumps(DEFAULT_FACTS)
    except:
        return json.dumps(DEFAULT_FACTS)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=8081)
