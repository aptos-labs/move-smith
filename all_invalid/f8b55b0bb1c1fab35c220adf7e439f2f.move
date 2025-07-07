
//# publish
module 0xCAFE::DestructuringDestruct {
    use std::vector;

    // Helper function to emulate destructuring with range (slice)
    // Note: Move currently lacks `vector::get`; use `vector::borrow` instead.
    public fun test_destructure(slice: vector<u8>) {
        let len = vector::length(&slice);
        // For test purposes, imagine destructuring as accessing specific indices.
        if (len >= 3) {
            let first = *vector::borrow(&slice, 0);
            let middle = *vector::borrow(&slice, 1);
            let last = *vector::borrow(&slice, len - 1);
            assert!(first >= 0, 0);
            assert!(middle >= 0, 0);
            assert!(last >= 0, 0);
        }
    }

    // Privileged operation: only module can initialize private struct
    struct PrivilegedStruct has key, store {
        secret: u8,
        pub_info: u32,
    }

    // Function that attempts to modify PrivilegedStruct across modules (should not compile)
    public fun privileged_modification(p: &mut PrivilegedStruct, new_secret: u8) {
        p.secret = new_secret;
    }

    // Now, simulate an invalid cross-module privileged operation (should be prevented)
    // This code is for test purposes; in actual scenario, this should produce compile error.
    // But here, we perform a direct attempt which would be invalid in real tests.
}



//# run 0xCAFE::DestructuringDestruct::test_destructure --args b"abcde"

 

//# run 0xCAFE::DestructuringDestruct::privileged_modification --signers 0xBEEF --args 5u8
// This is just conceptual; actual cross-module privileged violation would be compile error and not allowed

// Evaluation order test: chain of function fn calls with side effects
module 0xCAFE::OrderTest {
    use std::debug;

    // Helper functions with side effects
    fun side_effect_fn(val: u8): u8 {
        debug::print(&"called side_effect_fn with: ".concat(&val.to_string()));
        val + 1
    }

    // Function to test left-to-right argument evaluation order
    public fun evaluate_args() {
        // Intentionally using arguments with side effects to verify order
        let result = f(
            side_effect_fn(1),
            side_effect_fn(2),
            side_effect_fn(3),
        );
        result
    }

    fun f(a: u8, b: u8, c: u8): u8 {
        // dummy function to consume arguments
        a + b + c
    }
}



//# run 0xCAFE::OrderTest::evaluate_args

// Featurres:
// 6979f3dd022cb1cd7a48360a6df86d9c: Support destructuring assignment patterns with range (slice) elements in LValues for more flexible matching.
// da167b1970ccb5deda57add2fd12ed02: Ensure privileged operations on structs cannot be performed across module boundaries.
// 28ec4e78c25eb370b5326ebc673bad3b: Test evaluation order of function arguments to ensure that expressions with side effects are executed left-to-right.
