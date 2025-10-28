# Cloud Run expects the container to listen on $PORT (default 8080)
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Gunicorn binds to 0.0.0.0:$PORT in Cloud Run
ENV PORT=8080
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
