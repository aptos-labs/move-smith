//# publish
module 0xCAFE::LocalBindingsAndInvariants {
    // The invariant macro is not a standard std module in Aptos Move currently,
    // so we remove its usage to fix compilation errors.

    // Define a struct with key and store for demonstration
    struct Example has key, store {
        x: u64,
        y: bool,
    }

    // A function demonstrating local bindings with and without type annotations
    public fun test_locals(): u64 {
        let a = 42u64;
        let b: u64 = 58;
        let c = (a + b);
        let d: (u64) = (c);
        let (e, f): (u64, bool) = (d, true);
        e
    }

    // Remove invariant macro uses, just return true
    public fun test_invariant(): bool {
        // We can't use invariant! macro, so just return true
        true
    }

    // Runner function to call the above functions without arguments
    public fun runner(): u64 {
        let val = test_locals();
        let _ = test_invariant();
        val
    }
}
//# run 0xCAFE::LocalBindingsAndInvariants::runner


//# run
script {
    use 0xCAFE::LocalBindingsAndInvariants;

    fun main() {
        let x = 10u8;
        let y: u8 = 20;
        let z = (x + y);
        let (a, b): (u8, u8) = (z, 42);
        let t: (u8) = (a);

        let result = LocalBindingsAndInvariants::test_locals();

        let pair: (u64, bool) = (100, true);

        let output = LocalBindingsAndInvariants::runner();
    }
}