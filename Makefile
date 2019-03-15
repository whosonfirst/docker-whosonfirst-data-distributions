OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')

tools:
	docker build -f Dockerfile.tools -t whosonfirst-data-distributions-tools .

docker:
	@make tools
	docker build -f Dockerfile -t whosonfirst-data-distributions .
