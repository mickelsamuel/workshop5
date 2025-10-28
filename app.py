import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.get("/")
def root():
    return jsonify(
        service=os.environ.get("SERVICE_NAME", "workshop5"),
        message="Hello from Cloud Run!",
        region=os.environ.get("REGION", "unknown")
    )

if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))
    app.run(host="0.0.0.0", port=port)
