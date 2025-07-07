
//# publish
module 0xCAFE::LoopAndFunctionTest {
    use std::vector;

    // A memory cell to store a function with // persistent] attribute
    struct PersistentFunction has key {
        func: fn() -> u64,
    }

    // Function marked with // persistent], for the purpose of test
    public fun persistent_fn(): u64 {
        42 // Arbitrary return value for testing
    }

    // Helper to create a persistent function value
    public fun create_persistent_fn(): fn() -> u64 {
        // Returning the function item directly; no overloads or generics needed.
        persistent_fn
    }

    // A complex pattern involved in assignment
    public fun assign_complex_pattern() {
        let (mut a, mut b) = (0u64, 0u64);
        let arr: vector<u64> = vector::empty();

        let (x, (y, z)) = (1u64, (2u64, 3u64));
        a = x;
        b = y;
        vector::push_back(&mut arr, z);
        // Assign to a complex pattern: swapping
        (a, b) = (b, a);
    }

    // Function with a for loop including initialization, invariant, and body.
    public fun test_for_loop(limit: u64): u64 {
        let sum: u64 = 0;
        let i: u64 = 0;

        // For loop with initialization
        for (i = 0; i < limit; i = i + 1) {
            // Loop body
            sum = sum + i;
        }

        sum
    }

    // Store a persistent function in a struct, and call it after retrieval.
    public fun store_and_call_fn(): u64 {
        let sf = PersistentFunction { func: create_persistent_fn() };
        // Move the struct to storage
        move_to<&PersistentFunction>(&0xCAFE, sf);
        let sf_ref: &PersistentFunction = borrow_global<PersistentFunction>(&0xCAFE);
        // Call the stored function
        let result = (sf_ref.func)();
        result
    }
}



//# run 0xCAFE::LoopAndFunctionTest::test_for_loop --args 10



//# run 0xCAFE::LoopAndFunctionTest::assign_complex_pattern



//# run 0xCAFE::LoopAndFunctionTest::store_and_call_fn