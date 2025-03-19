FROM python:3.9-slim
WORKDIR /app
WORKDIR /app/cache
COPY requirements.txt .
RUN pip install --disable-pip-version-check --cache-dir /app/cache -r requirements.txt
COPY . .
# Command to run the application using gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]