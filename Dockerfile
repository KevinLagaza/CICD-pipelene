FROM python:3.10-slim
# Create a new user and group
RUN groupadd -r appuser && \
    useradd -r -g appuser appuser
# Create directories
WORKDIR /app
WORKDIR /app/cache
# Grant permissions
RUN chown -R appuser:appuser /app
RUN chown -R appuser:appuser /app/cache
# Switch to the new user
USER appuser
# Copy only the necesserary files
COPY --chmod=755 requirements.txt .
COPY --chmod=755 ./terraform .
COPY --chmod=755 ./app.py .
COPY --chmod=755 ./sonar-project.properties .
# Install all the required packages
RUN pip install --disable-pip-version-check --cache-dir /app/cache -r requirements.txt
# Command to run the application using gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
