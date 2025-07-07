//# publish --print-bytecode
module 0xA11C::Rand {

    /// Function `foo` returns the sum of 1 and 1.
    public fun foo(): u64 {
        1 + 1
    }

    /// Function `bar` asserts that `foo()` returns 2.
    public fun bar() {
        assert!(foo() == 2, 1);
    }

    /// Function `apply` applies a provided function `f` to two u64 values.
    public inline fun apply(f: |u64, u64|u64, x: u64, y: u64): u64 {
        f(x, y)
    }

    /// Utility function that adds two numbers, used as a callback.
    public fun add(x: u64, y: u64): u64 {
        x + y
    }
}

//# run 0xA11C::Rand::bar

//# run 0xA11C::Rand::apply --signers 0xA11C --args 3u64 4u64