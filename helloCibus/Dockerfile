# Base image
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Python (Ubuntu 24.04 provides Python 3.12)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verify Python version (important for assignment clarity)
RUN python3 --version

# Create non-root user
RUN useradd -m -u 10001 appuser

WORKDIR /app

# Copy files
COPY src/ ./src/
COPY requirements.txt .

# Create virtualenv and install dependencies
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Add venv to PATH
ENV PATH="/opt/venv/bin:$PATH"

# Fix permissions
RUN chown -R appuser:appuser /app /opt/venv

# Switch to non-root user
USER appuser

EXPOSE 8000

# Run app
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
