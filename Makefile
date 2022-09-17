FRONT_END_BINARY=frontApp
AUTH_BINARY=authApp
BROKER_BINARY=brokerApp

## up: starts all containers in the background without forcing rebuild
up:
	@echo "Starting Docker images..."
	docker-compose up -d
	@echo "Docker images started!"

## down: stop docker compose
down:
	@echo "Stopping docker compose..."
	docker-compose down
	@echo "Done!"

## up_build: stops docker-compose if running and builds all services, then restarts docker-compose
up_build: build_auth build_broker
	@echo "Stopping Docker images if running..."
	docker-compose down
	@echo "Building as required and starting Docker images..."
	docker-compose up --build -d
	@echo "Docker images built and started!"

## build_auth: builds the authentication binary as a linux executable
build_auth:
	@echo "Building authentication binary.."
	cd ../authentication-service && env GOOS=linux CGO_ENABLED=0 go build -o ${AUTH_BINARY} ./cmd/api
	@echo "Authentication binary built!"

## build_broker: builds the broker binary as a linux executable
build_broker:
	@echo "Building broker service binary..."
	cd ../broker-service && env GOOS=linux CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./cmd/api
	@echo "Done!"

## start: starts the front end
start:
	@echo "Starting front-end..."
	cd ../front-end && ./${FRONT_END_BINARY} &

## stop: stops the front end
stop:
	@echo "Stopping front end..."
	@-pkill -SIGTERM -f "./${FRONT_END_BINARY}"
