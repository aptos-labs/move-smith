
//# publish
module 0xCAFE::TestIncrementAccess {
    use std::vector;
    use 0xCAFE::MyModule;

    // Function to test increment implementations
    public fun test_increment_u8(x: u8): u8 {
        // Using f1, which adds 1 to input
        MyModule::f1(x, false)
    }

    public fun test_increment_struct(s: &mut MyModule::S): u32 {
        let new_x = s.x + 1;
        s.x = new_x;
        s.y = s.y + 1;
        s.x + s.y
    }

    public fun test_increment_wrapper(w: &mut MyModule::StructWithTypeParameter<u8>): u8 {
        let new_val = w.field + 1;
        w.field = new_val;
        new_val
    }

    public fun test_increment_vector(vec: &mut vector<u8>, index: u64): u8 {
        let val = *vector::borrow_mut(vec, index);
        let new_val = val + 1;
        vector::borrow_mut(vec, index) = new_val;
        new_val
    }

    // Function to access various fields
    public fun test_accesses(s: &MyModule::S, w: &MyModule::StructWithTypeParameter<u8>, vec: vector<u8>, index: u64): (u32, u8, u8, u8) {
        let x_val = s.x;
        let w_val = w.field;
        let vec_val = *vector::borrow(&vec, index);
        (x_val, w_val, vec_val, s.y)
    }

    // Function to call access_warning with message
    public fun trigger_warning() {
        // In Move, for testing, simulate a warning by calling access_warning
        // (In real Move, access_warning is a runtime trap, so we simulate its call)
        // Here, just invoke the function with a message.
        // Note: access_warning is a built-in function
        access_warning(b"Operations can only be performed within the authorized module");
    }

    // Function to test lambda evaluation order and once execution
    public fun test_lambda_order_in_eval(
        cause_side_effects: &mut vector<u64>,
        side_effect_value: u64,
        lambda: |u64| u64
    ): u64 {
        cause_side_effects.push_back(side_effect_value);
        lambda(side_effect_value)
    }
}


//# run 0xCAFE::TestIncrementAccess::test_increment_u8 --args 10u8

//# run 0xCAFE::TestIncrementAccess::test_increment_struct --args 5u32 7u32

//# run 0xCAFE::TestIncrementAccess::test_increment_wrapper --args 3u8

//# run 0xCAFE::TestIncrementAccess::test_increment_vector --args 42u8 0

//# run 0xCAFE::TestIncrementAccess::test_accesses --args 100u32 2u8 0 50u64

//# run 0xCAFE::TestIncrementAccess::trigger_warning

// Lambda evaluation order test

//# run 0xCAFE::TestIncrementAccess::test_lambda_order_in_eval --signers 0xBEEF --args 0 --args 99u64

// Featurres:
// eb9d496d4c6b5c330f13f8d6886363fe: Test that various implementations of increment and access functions for primitive types, structs, wrapped types, and vectors produce consistent and correct results across different usage patterns.
// c963c26356e55b2d69fb857b6a28e2eb: Call `access_warning` with appropriate message details to notify developers that certain operations can only be performed within a specific module.
// 6aec5cf5e5f1770b7f088e52bf462fde: Test that lambda/closure arguments to a function are evaluated in-order and exactly once, even when the arguments have side effects.
