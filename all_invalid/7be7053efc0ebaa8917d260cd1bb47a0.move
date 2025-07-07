
//# publish
module 0xCAFE::FeatureInteractionTest {
    // Use only std library modules
    use std::vector;
    use std::signer;

    // Define an internal-only struct
    struct InternalStruct has copy, drop {
        id: u64,
        name: vector<u8>,
    }
    // Note: No public access for InternalStruct

    // Define a struct with multiple fields for pattern matching
    struct MatchStruct has copy, drop {
        a: u32,
        b: bool,
        c: address,
    }

    // Internal function to compute sum
    fun internal_sum(a: u64, b: u64): u64 {
        a + b
    }

    // Public wrapper for internal_sum for testing
    public fun call_internal_sum(a: u64, b: u64): u64 {
        internal_sum(a, b)
    }

    // Function with native body (simulate native by just a placeholder here for testing)
    public fun native_function(x: u64): u64 {
        // Assume this is native; for test, just return x + 42
        x + 42
    }

    // Function with statement body
    public fun statement_body(x: u64): u64 {
        let y = x + 1;
        y * 2
    }

    // Function to test lambda partial application and invocation
    public fun lambda_test() {
        let add_u8 = |a: u8, b: u8| -> u8 {
            a + b
        };
        let add_five = |x: u8| -> u8 {
            add_u8(5u8, x)
        };
        let result = add_five(10u8);
        assert!(result == 15u8, 101);
    }
}

// Top-level script to verify feature interaction and control flow

//# run
script {
    // Invoke public functions with parameters
    let res1 = 0xCAFE::FeatureInteractionTest::call_internal_sum(10, 20);
    assert!(res1 == 30, 999);

    let res2 = 0xCAFE::FeatureInteractionTest::statement_body(5);
    assert!(res2 == 12, 999);

    let res3 = 0xCAFE::FeatureInteractionTest::native_function(58);
    assert!(res3 == 100, 999);

    // Variable shadowing test:
    let x = 0u64;
    let outer_x = x;
    let i = 0;
    while (i < 5) {
        let x = i; // shadow outer_x
        outer_x = outer_x + x; // add shadowed variable
        i = i + 1;
    };
    // After loop, outer_x should be sum of 0+1+2+3+4=10
    assert!(outer_x == 10, 999);

    // Declare local variable outside and inside loop
    let sum = 0u64;
    let index = 0;
    let local_var = 100u64;
    while (index < 3) {
        let local_var = local_var + index; // shadow local_var
        sum = sum + local_var;
        index = index + 1;
    };
    // inner local_var is shadowed, outer remains unchanged
    assert!(sum == (100+0)+(100+1)+(100+2), 999);
    // Confirm outer local_var unchanged
    assert!(local_var == 100, 999);

    // Pattern matching on struct with ownership
    let s = 0xCAFE::FeatureInteractionTest::MatchStruct {
        a: 42,
        b: true,
        c: @0x1,
    };
    match (s) {
        (MatchStruct { a: a_val, b: b_val, c: c_addr }) => {
            assert!(a_val == 42, 999);
            assert!(b_val == true, 999);
            assert!(c_addr == @0x1, 999);
        },
    };

    // Pattern matching with tuple and named fields
    let pair = (true, 123u8);
    match (pair) {
        (flag, value) => {
            assert!(flag == true, 999);
            assert!(value == 123u8, 999);
        },
    };

    // Use lambda defined in module
    0xCAFE::FeatureInteractionTest::lambda_test();

    // Call functions with body implementations
    let val_native = 0xCAFE::FeatureInteractionTest::native_function(20);
    assert!(val_native == 62, 999);
    let val_statement = 0xCAFE::FeatureInteractionTest::statement_body(7);
    assert!(val_statement == 16, 999);
}


//# run 0xCAFE::FeatureInteractionTest::call_internal_sum --args 50u64 70u64

//# run 0xCAFE::FeatureInteractionTest::statement_body --args 9u64

//# run 0xCAFE::FeatureInteractionTest::native_function --args 58u64

//# run 0xCAFE::FeatureInteractionTest::lambda_test


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 50ee0c7b7d1856d5244efa476d5a1a06: Use lambda expressions that partially apply existing functions, except that such lambda lifting is not allowed in scripts.
// 9d446a052e07802cc55f6d13ba427760: Test that struct pattern matching and field projection—both via tuple-style and named-field patterns, for owned values and references, and with and without type abilities—works correctly in function bodies and lets bindings.
// 3e3f947c7d1b4fc19e7bdb8b4bee8efe: Create functions with a body that can be either native or defined by a sequence of statements.
