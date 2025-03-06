debug: move-smith

release:
	cargo clean
	cargo build --bin move-smith --features git_deps --release
	cargo build --bin move-smith-local --features local_deps --release

move-smith:
	cargo build --bin move-smith --features git_deps

move-smith-local:
	cargo build --bin move-smith-local --features local_deps

fuzz-targets:
	cargo fuzz build v1v2 -s=none
	cargo fuzz build opt-noopt -s=none

install-deps:
	cargo install cargo-fuzz
	cargo install cargo-afl
	cargo install cargo-binutils
	cargo install honggfuzz

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
