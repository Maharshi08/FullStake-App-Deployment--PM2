from flask import Flask, jsonify, request, send_from_directory
import os
from flask_cors import CORS
from config import Config

app = Flask(__name__, static_folder='../frontend/dist/frontend/browser')
app.config.from_object(Config)
CORS(app)

@app.route("/")
def home():
    return send_from_directory(app.static_folder, 'index.html')

@app.route("/api/message")
def message():
    return jsonify({"message": "Hello from Flask Backend!" })

@app.route("/api/echo", methods=["POST"])
def echo():
    data = request.get_json()
    return jsonify({"echo": data.get("message", "")})

@app.route('/<path:path>')
def static_proxy(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(path)

if __name__ == "__main__":
    port = os.environ.get('PORT', 5000)
    app.run(debug=True, port=port)
