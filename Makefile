DOCKER_RUN_CMD:=docker run --rm -v $(PWD):/app -w /app lua-easy-crypto

test: build/docker
	$(DOCKER_RUN_CMD) busted spec

build:
	$(DOCKER_RUN_CMD) luarocks make

publish:
	$(DOCKER_RUN_CMD) luarocks upload lua-easy-crypto*.rockspec --api-key=$(LUAROCKS_API_KEY)

build/docker:
	docker build -t lua-easy-crypto .

clean:
	docker rm -f lua-easy-crypto

pack:
	docker run --rm -v $(PWD):/app -w /app lua-easy-crypto /bin/bash -c "luarocks pack lua-easy-crypto"
