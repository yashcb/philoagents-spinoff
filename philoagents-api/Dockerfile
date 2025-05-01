FROM python:3.11-slim

# Install uv.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set the working directory.
WORKDIR /app

# Set Python Path for the `src` directory.
ENV PYTHONPATH=/app/src

# Install the application dependencies.
COPY uv.lock pyproject.toml README.md ./
RUN uv sync --frozen --no-cache

# Copy the application into the container.
COPY src src/
COPY tools tools/

CMD ["/app/.venv/bin/uvicorn", "philoagents/infrastructure/api:app", "--host", "0.0.0.0", "--port", "8000"]
