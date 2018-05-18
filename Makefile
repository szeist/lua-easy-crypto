test:
	busted --lua=luajit spec

build:
	luarocks make --local

publish:
	luarocks upload lua-easy-crypto*.rockspec --api-key=$(LUAROCKS_API_KEY)