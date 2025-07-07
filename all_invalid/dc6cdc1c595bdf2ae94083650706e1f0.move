
//# publish
module 0xFACE::ComprehensiveTest {
    // Use std to access core functionalities
    use std::vector;
    use std::signer;

    // Internal resource with internal visibility to test access restrictions
    struct InternalResource {
        value: u64,
    }

    // Only accessible within this module
    public fun create_internal_resource(s: &signer): InternalResource {
        InternalResource { value: 42 }
    }

    // Internal function with internal visibility
    fun internal_helper(x: u64): u64 {
        x + 10
    }

    // Public function calling internal helper (via inline call)
    public fun call_internal_helper(x: u64): u64 {
        internal_helper(x)
    }

    // Function attempting to access internal resource outside module (should not compile)
    // This is a test; in actual test environment, trying access outside should fail.
    // Here, just declare the function to see internal access restrictions.
    public fun try_access_internal(s: &signer): u64 {
        // move_from<InternalResource>(signer::address_of(s)); // Should fail if uncommented
        0
    }
}

// Script to instantiate variables, shadow variables in loops, and test various features

//# run
script {
    // Declare variables with shadowing in nested loops and while
    let x: u64 = 5;
    let y: u64 = x;
    let i: u64 = 0;

    // While loop with variable shadowing
    while (i < 3) {
        let x: u64 = i + 10; // Shadow outer x
        y = y + x; // Accumulate shadowed x
        i = i + 1;
    };

    // Call module function that invokes internal
    let result = 0xFACE::ComprehensiveTest::call_internal_helper(50);
    // result should be 60 (50 + 10)

    // Access internal resource and test restricted access (commented out, should fail)
    // let _ = 0xFACE::ComprehensiveTest::try_access_internal(&signer::borrow(&signer::new_account()),); // Uncomment to test restriction

    // Create vector and test sequences
    let vec: vector<u8> = vector::empty();
    vector::push_back(&vec, 1);
    vector::push_back(&vec, 2);
    vector::push_back(&vec, 3);

    let element_0 = *vector::borrow(&vec, 0);
    let element_1 = *vector::borrow(&vec, 1);

    // Sequence expression with single expression
    let sum = (element_0 + element_1);
}

// Additional script to instantiate and verify move functions with mutable references and sequences

//# run
script {
    // Call function with the mutable reference, only to test that it compiles and runs
    let result1 = 0xFACE::ComprehensiveTest::call_internal_helper(100);
    // Do not call mutable functions directly outside; ensure code compliance

    // Test sequence with multiple expressions
    let sequence_result = ( {
        let a: u8 = 10;
        let b: u8 = 20;
        a + b
    }, {
        let c: u8 = 30;
        c * 2
    });

    // Verify shadowing and scope
    let outer_var: u64 = 0;
    let sequence_value = if (outer_var == 0) {
        let outer_var: u64 = 100; // Shadow outer
        outer_var + 1
    } else {
        0
    };
    // The sequence_value should be 101 when outer_var == 0
}


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 9f43511cd9a4df056c2af6b92f0ea7d3: Avoid calling move functions with mut ref parameters to maintain purity.
// 60950f7a10df64626cbcbfcece55e39c: Use sequences within binary operations only when they are trivial, meaning they consist of a single expression or are potentially side-effect-free.
