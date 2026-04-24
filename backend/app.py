from flask import Flask, jsonify, request
import os
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route("/api/message", methods=["GET"])
def message():
    return jsonify({"message": "Hello from Flask Backend!"})

@app.route("/api/echo", methods=["POST"])
def echo():
    data = request.get_json()
    if not data:
        return jsonify({"error": "No JSON data provided"}), 400
    
    return jsonify({"echo": data.get("message", "")})

if __name__ == "__main__":
    port = int(os.getenv('PORT', 8010))
    app.run(host="0.0.0.0", port=port, debug=False)