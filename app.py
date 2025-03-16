import requests
import os
from google.cloud import storage
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def fetch_data():
    """ Fetch data from API 
    """
    try:
        API_URL = os.getenv("API_URL")
        bucket_name = os.getenv("GCS_BUCKET_NAME")
        response = requests.get(API_URL)
        response.raise_for_status()
        data = response.json()
        # Store data in Google Cloud Storage
        client = storage.Client()
        bucket = client.bucket(bucket_name)
        blob = bucket.blob("api_data.json")
        blob.upload_from_string(str(data))
        return jsonify(data)
    except requests.exceptions.RequestException as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)