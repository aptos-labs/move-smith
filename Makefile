.PHONY: all debug release msmith msmith-local fuzz-targets test clean format install-deps

debug: msmith msmith-local

all: release fuzz-targets

release:
	cargo clean
	cargo build --bin msmith --release
	cargo build --bin msmith-local --no-default-features --features local_deps --release

msmith:
	cargo build --bin msmith

msmith-local:
	cargo build --bin msmith-local --no-default-features --features local_deps

fuzz-targets:
	cargo fuzz build v1v2 -s=none
	cargo fuzz build opt-noopt -s=none
	cargo fuzz build random -s=none
	cd fuzz && cargo hfuzz build --bin hfuzz-v1v2
	cd fuzz && cargo afl build --bin afl-v1v2

test:
	cargo nextest run

clean:
	cargo clean

format:
	cargo fmt
	cargo sort
	cargo sort enuminto
	cargo sort framework
	cargo sort fuzz
	cargo sort msmith 

install-deps:
	cargo install cargo-fuzz
	cargo install cargo-afl
	cargo install cargo-binutils
	cargo install honggfuzz
	cargo install cargo-sort
	cargo install cargo-nextest --locked

build-docker:
	docker build --build-arg HOST_UID=$$(id -u) --build-arg HOST_GID=$$(id -g) -t move-smith .
