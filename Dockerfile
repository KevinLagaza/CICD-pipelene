FROM python:3.9-slim
WORKDIR /app
WORKDIR /app/cache
COPY requirements.txt .
RUN pip install --disable-pip-version-check --cache-dir /app/cache -r requirements.txt
COPY . .
CMD ["python", "app.py"]