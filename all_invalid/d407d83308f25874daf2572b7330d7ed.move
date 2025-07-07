// Define a global constant with attribute
const MY_CONST: u8 = 42;

// Define an enum to use in the constant (enum is top-level like struct)

//# publish
module 0xCAFE::ConstantsTest {
    use std::assert;

    // Enum with copy and drop abilities
    enum Status has copy, drop {
        Active,
        Inactive,
    }

    // Function to test constant accessibility
    public fun get_const(): u8 {
        MY_CONST
    }

    // Function that accepts a lambda/closure and calls it
    public fun call_lambda(f: |u8| -> u8, val: u8): u8 {
        f(val)
    }

    // Wrapper to evaluate ordering
    public fun test_ordering() {
        // Side effects flags as mutable references
        // Move does not support bool as mutable local variables directly,
        // so we need to use global resources or inline mutable references.
        // But since this is a test, we'll declare them as local booleans
        // and wrap the lambdas in the same scope.

        // Initialize side effect flags as local mutable values
        let side_effect1 = false;
        let side_effect2 = false;

        // Define lambdas with side effects
        let lambda1: |u8| -> u8 = |x: u8| {
            assert!(side_effect1 == false, 999);
            side_effect1 = true;
            x + 1
        };

        let lambda2: |u8| -> u8 = |x: u8| {
            assert!(side_effect2 == false, 998);
            side_effect2 = true;
            x + 2
        };

        // Call test_ordering with lambdas, evaluate in specific order
        let result1 = call_lambda(&lambda1, 10);
        let result2 = call_lambda(&lambda2, result1);
        // expecting side_effect1 to be true
        assert!(side_effect1, 1000);
        // expecting side_effect2 to be true
        assert!(side_effect2, 1001);
        // Final result check
        assert!(result2 == 13, 1002);
    }
}


//## Run the following commands to test constants and lambda evaluation


//# run 0xCAFE::ConstantsTest::get_const


//# run 0xCAFE::ConstantsTest::test_ordering

// Features:
// 450f5473644abac25d250627fc5d9d9a: Define constants with attributes and signatures
// f4d7f8ca94166c96bec2005e0e98ffa4: Constant declarations cannot be marked with the 'entry' modifier; this is only for functions.
// 6aec5cf5e5f1770b7f088e52bf462fde: Test that lambda/closure arguments to a function are evaluated in-order and exactly once, even when the arguments have side effects.
