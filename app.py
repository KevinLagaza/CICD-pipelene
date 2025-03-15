import requests
import os
from google.cloud import storage
from github import Github

# Fetch data from API
API_URL = "https://jsonplaceholder.typicode.com/posts"

def fetch_data():
    response = requests.get(API_URL)
    response.raise_for_status()
    return response.json()

# Store data in Google Cloud Storage
def store_in_gcs(bucket_name, data):
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    blob = bucket.blob("api_data.json")
    blob.upload_from_string(str(data))

# Push data to GitHub repository
# def push_to_github(repo_name, data, github_token):
#     g = Github(github_token)
#     repo = g.get_repo(repo_name)
#     repo.create_file("api_data.json", "Update API data", str(data))

if __name__ == "__main__":
    # Fetch data
    data = fetch_data()

    # Store in GCS
    bucket_name = os.getenv("GCS_BUCKET_NAME")
    if bucket_name:
        store_in_gcs(bucket_name, data)

    # Push to GitHub
    # repo_name = os.getenv("GITHUB_REPO_NAME")
    # github_token = os.getenv("GITHUB_TOKEN")
    # if repo_name and github_token:
    #     push_to_github(repo_name, data, github_token)