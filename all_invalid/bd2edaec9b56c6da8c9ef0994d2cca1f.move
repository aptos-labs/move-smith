
//# publish
module 0xBABE::InteractionTest {
    use std::signer;
    use std::vector;

    // Constants and types used for internal testing
    const TEST_CONST: u8 = 42;

    // Private function, supposed to test module internal access
    fun internal_private_function(): u8 {
        100
    }

    // Public function to test module interaction with other modules
    public fun public_accessible_function(): u8 {
        200
    }

    // Function with local variables and loops; no shadowing
    public fun variable_and_loop_test(x: u64): u64 {
        let counter = 0;
        let result = 0;
        while (counter < x) {
            let temp = counter * 2; // local variable shadowing test
            result = result + temp;
            counter = counter + 1;
        };
        result
    }

    // Function that shadow shadows previous variable
    public fun variable_shadow_test(y: u8): u8 {
        let y = y + 1; // shadowing outer y
        y
    }

    // Function using references to test borrow rules
    public fun reference_safety_test(v: &vector<u8>): u8 {
        let first = vector::borrow(v, 0);
        *first
    }

    // Function to test lambda lifting (simulate by passing functions)
    public fun apply_function(f: |u8|u8, val: u8): u8 {
        f(val)
    }

    // A simple lambda function as an inline function
    public fun lambda_increment(): |u8|u8 {
        |x: u8| { x + 1 }
    }

    // A friend function simulating internal access
    public fun friend_function(): u8 {
        internal_private_function()
    }
}



//# run 0xBABE::InteractionTest::variable_and_loop_test --args 10u64



//# run 0xBABE::InteractionTest::variable_shadow_test --args 5u8



//# run 0xBABE::InteractionTest::reference_safety_test --args 0xDEAD::RefContainer::get_first --signers 0xDEAD



//# run 0xBABE::InteractionTest::apply_function --args 0xBABE::InteractionTest::lambda_increment --args 10u8



//# run 0xBABE::InteractionTest::friend_function


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 50ee0c7b7d1856d5244efa476d5a1a06: Use lambda expressions that partially apply existing functions, except that such lambda lifting is not allowed in scripts.
// 7bd4a348fb0b20c70f26990142b873c4: Verify that references are used safely and conform to Move's reference safety guarantees.
// 5a93f8922a3f80b6cbf1c7f536622223: Enforce module privacy rules based on friendship relationships during function calls.
