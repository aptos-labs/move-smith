all:
	RUSTFLAGS="-C instrument-coverage -Zcoverage-options=branch" cargo build
	rm -rf *.profraw