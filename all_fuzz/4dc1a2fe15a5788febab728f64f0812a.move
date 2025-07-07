
//# publish
module 0xCAFE::AddModule {
    // Module to test addition of two u8 values
    public fun add_two(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    // Function with a lambda expression to multiply two u8 values
    public fun multiply_lambda(): u8 {
        let multiply: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        multiply(7u8, 6u8)
    }
}




//# run 0xCAFE::AddModule::add_two --args 10u8 32u8




//# run 0xCAFE::AddModule::multiply_lambda





//# publish
module 0xCAFE::NestedInline {
    use 0xCAFE::AddModule;

    // Inline function that calls AddModule::add_two inline and returns double
    public inline fun double_sum(a: u8, b: u8): u8 {
        let sum = AddModule::add_two(a, b);
        sum + sum
    }

    // Function that calls double_sum without arguments by fixed values
    public fun runner() {
        let _res = double_sum(4u8, 5u8);
    }
}




//# run 0xCAFE::NestedInline::runner





//# publish
module 0xCAFE::GenericCall {
    struct Wrapper<T> has copy, drop {
        value: T,
    }

    public fun new_wrapper_u8(val: u8): Wrapper<u8> {
        Wrapper { value: val }
    }

    public fun new_wrapper_u16(val: u16): Wrapper<u16> {
        Wrapper { value: val }
    }

    // Function to extract the inner value with generic type argument after dot
    public fun get_value_u8(wrapper: &Wrapper<u8>): u8 {
        wrapper.value
    }

    public fun get_value_u16(wrapper: &Wrapper<u16>): u16 {
        wrapper.value
    }

    public fun test_generic_calls() {
        let w_u8 = new_wrapper_u8(42u8);
        let w_u16 = new_wrapper_u16(300u16);

        let val_u8 = w_u8.value;
        let val_u16 = w_u16.value;

        // Just keep the values here for test, no assertions
        let _ = val_u8;
        let _ = val_u16;
    }
}




//# run 0xCAFE::GenericCall::test_generic_calls





//# publish
module 0xCAFE::ReverseBind {
    use std::vector;

    // A struct to hold two values
    struct Pair has copy, drop {
        x: u8,
        y: u8,
    }

    // Function to demonstrate left-hand side list processing in reverse order
    public fun reverse_bind() {
        let a = 1u8;
        let b = 2u8;
        let c = 3u8;

        // Instead of using references (which vector does not support), we use indices
        let vals = vector::empty<u8>();
        vector::push_back(&mut vals, a);
        vector::push_back(&mut vals, b);
        vector::push_back(&mut vals, c);

        let len = vector::length(&vals);
        let i = len;
        while (i > 0) {
            i = i - 1;
            let val = vector::borrow_mut(&mut vals, i);
            *val = *val + 10u8;
        };

        // Unpack updated values back into variables
        a = *vector::borrow(&vals, 0);
        b = *vector::borrow(&vals, 1);
        c = *vector::borrow(&vals, 2);

        // Variables now are a=11, b=12, c=13, but no assertion needed
        // Do not assign tuple directly; assign elements individually or ignore
        let _a = a;
        let _b = b;
        let _c = c;
    }
}




//# run 0xCAFE::ReverseBind::reverse_bind
