all: build-server

build-server:
	docker build -t nodered-server -f nodered_server/nodered_server_python.Dockerfile nodered_server/.
