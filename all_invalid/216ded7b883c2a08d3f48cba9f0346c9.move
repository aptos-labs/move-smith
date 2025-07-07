
//# publish
module 0xBADD::TestModule {
    use std::vector;
    use std::signer;

    // A simple struct for test
    struct Data has copy, drop, store {
        value: u64,
    }

    // Helper to create a data object
    public fun create_data(val: u64): Data {
        Data { value: val }
    }

    // Function with multiple abort points, but returns a final value
    public fun process_with_abort(x: u64): u64 {
        if (x > 10) {
            abort 1;
        }
        if (x < 0) {
            abort 2;
        }
        // Should still run when x == 0 or x == 10, etc.
        let y = x + 100;
        y
    }

    // Inline function to test embedding
    public inline fun inline_check(a: u64): u64 {
        a * 2
    }

    // Function calling inline
    public fun call_inline(b: u64): u64 {
        inline_check(b)
    }

    // Function marked with expected_failure to check compile-time error
    // This should fail because `abort` is used improperly (simulate an error)
    // expected_failure]
    public fun faulty_function(): u64 {
        abort 999
        42
    }

    // Function to test byte string literal handling
    public fun check_byte_string(): vector<u8> {
        b"TestByteString"
    }

    // Function involving large vector constant over 800 elements
    public fun large_vector_const(): vector<u8> {
        // Generate a vector of 820 elements, all 0xAA
        let v = vector::empty<u8>();
        let i = 0;
        while (i < 820) {
            vector::push_back(&mut v, 0xAA);
            i = i + 1;
        };
        v
    }

    // Function to compare large vector to its construction
    public fun compare_large_vectors(): bool {
        let v1 = large_vector_const();
        let v2 = {
            let v = vector::empty<u8>();
            let j = 0;
            while (j < 820) {
                vector::push_back(&mut v, 0xAA);
                j = j + 1;
            };
            v
        };
        vector::equals(&v1, &v2)
    }
}


//# run 0xBADD::TestModule::process_with_abort --args 5u64


//# run 0xBADD::TestModule::process_with_abort --args 20u64


//# run 0xBADD::TestModule::call_inline --args 21u64


//# run 0xBADD::TestModule::check_byte_string


//# run 0xBADD::TestModule::compare_large_vectors

// Should trigger compile-time failure: using `faulty_function` which is expected to have an error

//# run 0xBADD::TestModule::faulty_function


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 1630878bb07f0e61d64057399656ba48: Test that the Move function correctly handles multiple aborts and continues execution to produce the expected final result.
// 42b25b93e4183728f064e19bece2cde4: Annotate code with expected failure attributes that do not take any parameters or assigned values.
// 1011b8aa32f48fef72a832a6a7a35814: Write Move code that is statically checked for bytecode-level correctness before execution
// 11a4d1fe9892131da3fe1e15c5bf28ca: Write code that calls inline functions and benefit from having those callees' bodies inlined into the caller.
// fa65d167136d555ab02c16ebe59fc8b7: Write byte string literals using b"..." syntax in your Move code
// 4a4fdcd953931b14d0f46289445e9339: Test that the Move compiler can handle constant expressions involving equality comparison of very large vectors (e.g., vectors of over 800 elements).
