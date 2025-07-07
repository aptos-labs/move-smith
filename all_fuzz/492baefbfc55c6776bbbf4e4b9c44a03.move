
//# publish
module 0xCAFE::AdditionLambda {
    // This module tests addition of two u8 values and uses lambda expressions

    public fun add_two_values(a: u8, b: u8): u8 {
        let result = a + b;
        // Return result + 10 to distinguish from simple addition
        result + 10
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = lambda(a, b);
        sum + 10 // Return sum + 10 as above
    }
}

// We define the missing MyModule with the inline function f2 as it's referenced in NestedInlineCall


//# publish
module 0xCAFE::MyModule {
    // Inline function f2 takes a u16 and returns a tuple (u16, u16)
    public inline fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }
}



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::MyModule;

    // Call MyModule::f2 inline function from this module and add results
    public fun nested_call(a: u16): u16 {
        let (x, y) = MyModule::f2(a);
        // sum the two values returned by inline function plus a constant 5
        x + y + 5
    }

    public fun nested_lambda_call(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = lambda(a, b);
        let final_result = Self::nested_helper(sum);
        final_result
    }

    fun nested_helper(x: u8): u8 {
        x + 100
    }
}



//# run 0xCAFE::AdditionLambda::add_two_values --args 5u8 7u8



//# run 0xCAFE::AdditionLambda::add_with_lambda --args 8u8 9u8



//# run 0xCAFE::NestedInlineCall::nested_call --args 20u16



//# run 0xCAFE::NestedInlineCall::nested_lambda_call --args 10u8 15u8
