all: build

build: bin/fosdem-recorder

bin/fosdem-recorder: $(wildcard src/*.cr)
	shards build

clean:
	rm -f bin/fosdem-recorder

