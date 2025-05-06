FROM python:3.11-slim

# Install uv.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set the working directory.
WORKDIR /app

# Install the application dependencies.
COPY uv.lock pyproject.toml README.md ./
RUN uv sync --frozen

# Ensure the application dependencies are installed in the system PATH.
ENV PATH="/app/.venv/bin:$PATH"

# Copy the application into the container.
COPY src/philoagents philoagents/
COPY tools tools/

# Expose the port for Google Cloud Run.
EXPOSE 8080

# Use the PORT environment variable provided by Cloud Run.
ENV PORT=8080

# Run the application using uvicorn.
CMD ["uvicorn", "philoagents.infrastructure.api:app", "--host", "0.0.0.0", "--port", "8080"]