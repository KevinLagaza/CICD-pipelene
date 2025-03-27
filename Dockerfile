FROM python:3.10-slim
WORKDIR /app
WORKDIR /app/cache
COPY requirements.txt .
RUN pip install --disable-pip-version-check --cache-dir /app/cache -r requirements.txt
COPY ./terraform .
COPY ./app.py .
COPY ./sonar-project.properties .
# Command to run the application using gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
