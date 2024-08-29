all: move-smith move-smith-local

move-smith:
	cargo build --bin move-smith --features git_deps

move-smith-local:
	cargo build --bin move-smith-local --features local_deps

install-deps:
	cargo install cargo-fuzz
	cargo install cargo-afl
	cargo install cargo-binutils
