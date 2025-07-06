# 1. Base Image: Python 3.10 slim
FROM python:3.10-slim

# 2. Prevent .pyc files and ensure stdout/stderr are unbuffered
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 3. Set working directory inside the container
WORKDIR /app

# 4. Copy only requirements first (for layer caching)
COPY requirements.txt .

# 5. Install dependencies (CPU‑only torch)
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# 6. Copy the rest of your application
COPY . .

# 7. Expose port 8000 (Flask/Gunicorn listens here)
EXPOSE 8000

# 8. Launch via Gunicorn
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000", "--workers", "2"]
