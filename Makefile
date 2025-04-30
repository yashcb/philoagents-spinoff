ifeq (,$(wildcard philoagents-api/.env))
$(error .env file is missing at philoagents-api/.env. Please create one based on .env.example)
endif

include philoagents-api/.env

# --- Infrastructure ---

infrastructure-build:
	docker compose build

infrastructure-up:
	docker compose up --build -d

infrastructure-stop:
	docker compose stop

check-docker-image:
	@if [ -z "$$(docker images -q philoagents-course-api 2> /dev/null)" ]; then \
		echo "Error: philoagents-course-api Docker image not found."; \
		echo "Please run 'make infrastructure-build' first to build the required images."; \
		exit 1; \
	fi

# --- Offline Pipelines ---

call-agent: check-docker-image
	docker run --rm --network=philoagents-network --env-file philoagents-api/.env -v ./philoagents-api/data:/app/data philoagents-course-api uv run python -m tools.call_agent --philosopher-id "turing" --query "How can we know the difference between a human and a machine?"

create-long-term-memory: check-docker-image
	docker run --rm --network=philoagents-network --env-file philoagents-api/.env -v ./philoagents-api/data:/app/data philoagents-course-api uv run python -m tools.create_long_term_memory

delete-long-term-memory: check-docker-image
	docker run --rm --network=philoagents-network --env-file philoagents-api/.env philoagents-course-api uv run python -m tools.delete_long_term_memory

generate-evaluation-dataset: check-docker-image
	docker run --rm --network=philoagents-network --env-file philoagents-api/.env -v ./philoagents-api/data:/app/data philoagents-course-api uv run python -m tools.generate_evaluation_dataset --max-samples 15

evaluate-agent: check-docker-image
	docker run --rm --network=philoagents-network --env-file philoagents-api/.env -v ./philoagents-api/data:/app/data philoagents-course-api uv run python -m tools.evaluate_agent --workers 1 --nb-samples 15
