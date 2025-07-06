# 1. Base Image: Python 3.10 slim
FROM python:3.10-slim

# 2. Disable bytecode writing and enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 3. Install OS‑level build tools & libraries
#    - build-essential: compiler toolchain
#    - ffmpeg & libsndfile1: audio handling for pydub/librosa
#    - libatlas3-base: BLAS/LAPACK for numpy/scipy
#    - pkg-config & python3-dev: for building C extensions
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      python3-dev \
      ffmpeg \
      libsndfile1 \
      libatlas3-base \
      pkg-config \
 && rm -rf /var/lib/apt/lists/*

# 4. Create & set working directory
WORKDIR /app

# 5. Copy only requirements first for layer caching
COPY requirements.txt .

# 6. Upgrade pip and install Python dependencies
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# 7. Copy application code
COPY . .

# 8. Expose listening port
EXPOSE 8000

# 9. Launch with Gunicorn
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000", "--workers", "2"]
