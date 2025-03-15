import requests
import os
from google.cloud import storage
from flask import Flask, jsonify

app = Flask(__name__)

# Fetch data from API
API_URL = "https://jsonplaceholder.typicode.com/posts"

@app.route("/")
def fetch_data():
    try:
        response = requests.get(API_URL)
        response.raise_for_status()
        # Store data in Google Cloud Storage
        client = storage.Client()
        bucket = client.bucket(bucket_name)
        blob = bucket.blob("api_data.json")
        blob.upload_from_string(str(data))
    except requests.exceptions.RequestException as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)