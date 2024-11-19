.PHONY: all debug release msmith msmith-local fuzz-targets test clean format install-deps

debug: msmith msmith-local

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
