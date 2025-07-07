// The transactional test exercises spec pragmas, tuple types, and cross-module inline function calls.

//# publish
module 0xCAFE::PragmaTuple {
    use std::vector;

    spec {
        pragma opaque("TupleTest", "This pragma is for testing spec pragmas.");
        pragma invariant true;
    }

    // A struct with a tuple field using anonymous fields 0 and 1.
    struct Pair has copy, drop, store, key {
        value: (u64, bool);
    }

    public fun create_pair(v: u64, b: bool): Pair {
        Pair { value: (v, b) }
    }

    public fun get_first(p: &Pair): u64 {
        // Access tuple field using index 0.
        let (x, _) = p.value;
        x
    }

    public fun get_second(p: &Pair): bool {
        let (_, y) = p.value;
        y
    }

    public fun runner() {
        let p = create_pair(42u64, true);
        let first = get_first(&p);
        let second = get_second(&p);
        // Just to make sure the compiler runs through this code path.
        if (first > 0 && second) {
            // no-op
        }
    }
}
 //# run 0xCAFE::PragmaTuple::runner --signers 0xCAFE

//# publish
module 0xCAFE::InlineCalled {
    // Declare an inline function that returns a u64.

    public inline fun add_one(x: u64): u64 {
        x + 1
    }

    public inline fun mul_two(x: u64): u64 {
        x * 2
    }
    
    // Compose two inline functions
    public inline fun add_one_then_mul_two(x: u64): u64 {
        mul_two(add_one(x))
    }

    public fun runner() {
        let a = 10u64;
        let res = add_one_then_mul_two(a);
        // res should be (10 + 1) * 2 = 22
        let expected = 22u64;
        // no assertions, just use values so compiler cannot optimize out completely
        if (res == expected) {
            // no-op
        }
    }
}
 //# run 0xCAFE::InlineCalled::runner --signers 0xCAFE

//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::InlineCalled;

    public fun runner() {
        // Call InlineCalled::add_one_then_mul_two inline function from another module
        let x = 7u64;
        // The call to add_one_then_mul_two is an inline function imported from another module.
        let res = InlineCalled::add_one_then_mul_two(x);
        // expected result: (7 + 1) * 2 = 16
        let expected = 16u64;
        if (res == expected) {
            // no-op
        }
    }
}
 //# run 0xCAFE::InlineCaller::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::PragmaTuple;
    use 0xCAFE::InlineCaller;
    use 0xCAFE::InlineCalled;

    fun main(_signer: signer) {
        // Test PragmaTuple module tuple and spec pragmas indirectly by calling runner
        PragmaTuple::runner();

        // Test InlineCalled nested inline functions
        InlineCalled::runner();

        // Test InlineCaller calling inline functions from InlineCalled
        InlineCaller::runner();
    }
}

// Featurres:
// c1f37f0ad4f80bbc9489d5bb0e018ba2: Declare spec pragmas using the 'pragma' keyword within spec blocks.
// 4cf2880fe87afa7d8e339827d2aa4ca1: Declare tuple types with anonymous fields in Move, using the syntax (Type1, Type2, ...), where fields are named '0', '1', etc.
// 955c55396c37e8737b7448f9f53c8bc6: Test that calling an inline function from one module within another correctly computes and returns the expected nested function result.
