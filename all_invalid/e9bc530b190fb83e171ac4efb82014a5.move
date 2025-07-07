module 0xCAFE::TestIncrementAccess {
    use std::vector;
    // Remove the use statement referencing 0xCAFE::MyModule
    // Use absolute paths for module functions and types

    // Function to test increment implementations
    public fun test_increment_u8(x: u8): u8 {
        // Qualify the function with the full address
        0xCAFE::MyModule::f1(x, false)
    }

    public fun test_increment_struct(s: &mut 0xCAFE::MyModule::S): u32 {
        let new_x = s.x + 1;
        s.x = new_x;
        s.y = s.y + 1;
        s.x + s.y
    }

    public fun test_increment_wrapper(w: &mut 0xCAFE::MyModule::StructWithTypeParameter<u8>): u8 {
        let new_val = w.field + 1;
        w.field = new_val;
        new_val
    }

    public fun test_increment_vector(vec: &mut vector<u8>, index: u64): u8 {
        let val = *vector::borrow_mut(vec, index);
        let new_val = val + 1;
        vector::borrow_mut(vec, index) = new_val; // invalid syntax: assignment to borrow_mut result
    }

    // Fix: borrowing mutably returns a mutable reference, which can be assigned to directly
    // Need to borrow_mut, then assign to the dereferenced value
    public fun test_increment_vector(vec: &mut vector<u8>, index: u64): u8 {
        let val_ref = vector::borrow_mut(vec, index);
        let new_val = *val_ref + 1;
        *val_ref = new_val;
        new_val
    }

    // Function to access various fields
    public fun test_accesses(
        s: &0xCAFE::MyModule::S,
        w: &0xCAFE::MyModule::StructWithTypeParameter<u8>,
        vec: &vector<u8>,
        index: u64
    ): (u32, u8, u8, u8) {
        let x_val = s.x;
        let w_val = w.field;
        let vec_val = *vector::borrow(vec, index);
        (x_val, w_val, vec_val, s.y)
    }

    // Function to call access_warning with message
    public fun trigger_warning() {
        // access_warning is a built-in function
        access::access_warning(b"Operations can only be performed within the authorized module");
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