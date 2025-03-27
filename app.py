import requests
import os
from google.cloud import storage
from flask import Flask, jsonify
from flask_wtf.csrf import CSRFProtect  # Correct import

app = Flask(__name__)
app.config['SECRET_KEY'] = os.get('SECRET_KEY')  # Required for CSRF
csrf = CSRFProtect(app)  # Initialize extension

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
