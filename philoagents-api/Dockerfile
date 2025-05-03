FROM python:3.11-slim

# Install system dependencies required for Python packages.
RUN apt-get update && apt-get install -y build-essential libpq-dev

# Install uv.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set the working directory.
WORKDIR /app

# Set PYTHONPATH to include the /app directory.
ENV PYTHONPATH=/app

# Install the application dependencies.
COPY uv.lock pyproject.toml README.md ./
RUN uv sync --frozen --no-cache

# Copy the application into the container.
COPY src/philoagents philoagents/
COPY tools tools/

# Debugging: List the contents of the /app directory.
RUN ls -la /app && ls -la /app/philoagents

# Expose the port Render will use.
EXPOSE 8000

# Use the PORT environment variable provided by Render.
CMD sh -c "/app/.venv/bin/uvicorn philoagents.infrastructure.api:app --host 0.0.0.0 --port ${PORT:-8000}"