.PHONY: all debug release msmith msmith-local fuzz-targets test clean format install-deps

msmith:
	cargo build --bin msmith

msmith-local:
	cargo build --bin msmith-local --no-default-features --features local_deps

all: release fuzz-targets

release:
	cargo clean
	cargo build --bin msmith --release
	cargo build --bin msmith-local --no-default-features --features local_deps --release

fuzz-targets:
	cargo fuzz build v1v2 -s=none
	cargo fuzz build opt-noopt -s=none
	cargo fuzz build random -s=none
	cd fuzz && cargo hfuzz build --bin hfuzz-v1v2
	cd fuzz && cargo afl build --bin afl-v1v2

debug:
	RUST_BACKTRACE=1 cargo run --bin msmith-debug

trace:
	RUST_LOG=TRACE RUST_BACKTRACE=1 cargo run --bin msmith-debug

test:
	cargo nextest run --no-capture

clean:
	cargo clean

nuke-fuzz:
	@read -p "Type Y to nuke fuzz: " ans && [ "$$ans" = Y ] || { echo "Cancelled."; exit 1; }
	cd fuzz && cargo clean && cargo hfuzz clean && cargo afl clean
	rm -rf fuzz/artifacts
	rm -rf fuzz/corpus
	rm -rf fuzz/coverage
	rm -rf fuzz/hfuzz_workspace
	rm -rf afl
	rm -rf coverage
	rm -rf logs

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
	cargo install rustfilt

build-docker:
	docker build --build-arg HOST_UID=$$(id -u) --build-arg HOST_GID=$$(id -g) -t move-smith .
