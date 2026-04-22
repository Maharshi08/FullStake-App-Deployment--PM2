from flask import Flask, jsonify, request, send_from_directory
import os
from flask_cors import CORS

app = Flask(__name__, static_folder='../frontend/dist/frontend/browser')

# ✅ FIX: Configure CORS properly for SSR proxy
CORS(app, resources={
    r"/api/*": {
        "origins": ["localhost", "127.0.0.1", "*"],
        "methods": ["GET", "POST", "OPTIONS"],
        "allow_headers": ["Content-Type"]
    }
})

@app.route("/api/message", methods=["GET", "OPTIONS"])
def message():
    return jsonify({"message": "Hello from Flask Backend!"})

@app.route("/api/echo", methods=["POST", "OPTIONS"])
def echo():
    if request.method == "OPTIONS":
        return jsonify({"status": "ok"}), 200
    
    data = request.get_json()
    if not data:
        return jsonify({"error": "No JSON data provided"}), 400
    
    return jsonify({"echo": data.get("message", "")})

# ✅ FIX: Serve static files with proper error handling
@app.route("/")
def home():
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/<path:path>')
def static_proxy(path):
    try:
        return send_from_directory(app.static_folder, path)
    except:
        return send_from_directory(app.static_folder, 'index.html')

if __name__ == "__main__":
    port = int(os.getenv('PORT', 8010))
    app.run(host="0.0.0.0", port=port, debug=False)