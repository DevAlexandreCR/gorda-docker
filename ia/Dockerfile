# Use Ubuntu as base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIPENV_VENV_IN_PROJECT=1

# Set working directory
WORKDIR /app

# Update package list and install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pipenv
RUN pip3 install pipenv

# Copy Pipfile and Pipfile.lock (if they exist)
COPY Pipfile* ./

# Install dependencies if Pipfile exists
RUN if [ -f "Pipfile" ]; then pipenv install --system --deploy; fi

# Create app directory structure
RUN mkdir -p /app/src

# Expose port (adjust as needed for your future application)
EXPOSE 8000

# Keep container running - you can create your app later
CMD ["tail", "-f", "/dev/null"]
