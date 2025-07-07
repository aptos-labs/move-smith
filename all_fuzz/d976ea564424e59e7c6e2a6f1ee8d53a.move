
//# publish
module 0xCAFE::MyModule {
    // Inline function f2 takes a u16 and returns a tuple (u16, bool)
    // For demonstration, it returns (x + 1, true)
    public inline fun f2(x: u16): (u16, bool) {
        (x + 1, true)
    }
}


//# publish
module 0xCAFE::AddAndLambda {
    // Function that adds two u8 values and returns the sum plus a constant offset 10u8
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function containing a lambda that multiplies two u8 values and returns the product
    public fun multiply_lambda(x: u8, y: u8): u8 {
        let mul: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a * b;
        mul(x, y)
    }

    // Function that calls the inline function f2 from 0xCAFE::MyModule and returns the first element of the tuple plus 5
    public fun call_inline_and_add(x: u16): u16 {
        let (val1, _) = 0xCAFE::MyModule::f2(x);
        val1 + 5
    }

    // Runner function that executes all above in one transactional call for testing
    public fun runner(): u8 {
        let add_result = add_with_offset(5u8, 7u8);
        let mul_result = multiply_lambda(3u8, 4u8);
        let inline_call_result = call_inline_and_add(20u16);

        // Return sum of all three results casted to u8 for simplification: 
        // 5+7+10=22, 3*4=12, (20+1)+5=26
        (add_result + mul_result) + (inline_call_result as u8)
    }
}


//# run 0xCAFE::AddAndLambda::add_with_offset --args 15u8 10u8


//# run 0xCAFE::AddAndLambda::multiply_lambda --args 6u8 7u8


//# run 0xCAFE::AddAndLambda::call_inline_and_add --args 100u16


//# run 0xCAFE::AddAndLambda::runner
