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
COPY --chown=appuser:appuser requirements.txt .
COPY --chown=appuser:appuser ./terraform .
COPY --chown=appuser:appuser ./app.py .
COPY --chown=appuser:appuser ./sonar-project.properties .
# Install all the required packages
RUN pip install --disable-pip-version-check --cache-dir /app/cache -r requirements.txt
# Command to run the application using gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
