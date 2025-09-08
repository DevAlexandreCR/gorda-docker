# IA Service

This is the IA (Artificial Intelligence) service container for the Gorda project.

## Requirements

- Python 3.10+
- pipenv

## Setup

The container is configured to keep running and provides a Python environment with pipenv.
You can create your application later and it will be available in the `/app` directory.

1. Start the container:
   ```bash
   docker-compose up ia
   ```

2. Access the container:
   ```bash
   docker exec -it ia_service bash
   ```

3. Inside the container, you can:
   - Install dependencies: `pipenv install <package>`
   - Create your application files in `/app`
   - Run your Python applications

## Docker

The service is containerized and runs continuously, ready for development.

## Configuration

- Add Python dependencies to the `Pipfile`
- Create your application files when ready
- The container keeps running with `tail -f /dev/null`
