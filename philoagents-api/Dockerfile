# Stage 1: Build Stage
FROM python:3.11-slim AS builder

# Install uv.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set the working directory.
WORKDIR /app

# Set Python Path for the `src` directory.
ENV PYTHONPATH=/app/src

# Install the application dependencies.
COPY uv.lock pyproject.toml ./
RUN uv sync --frozen --no-cache

# Copy the application into the container.
COPY src src/
COPY tools tools/

# Stage 2: Production Stage
FROM python:3.11-slim

# Set the working directory.
WORKDIR /app

# Set Python Path for the `src` directory.
ENV PYTHONPATH=/app/src

# Copy the virtual environment and application from the builder stage.
COPY --from=builder /app /app

# Expose the port Render will use.
EXPOSE 8000

# Use the PORT environment variable provided by Render.
CMD ["/app/.venv/bin/uvicorn", "philoagents/infrastructure/api:app", "--host", "0.0.0.0", "--port", "${PORT:-8000}"]