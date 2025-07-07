
//# publish
module 0xCAFE::AddAndLambda {
    // Test addition of two u8 values and return a specific value
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            100u8
        } else {
            50u8
        }
    }

    // Function containing lambda (anonymous function) expressions
    public fun compute_with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = adder(a, b);
        result * 2u8
    }

    // Expose a wrapper returning a tuple of u8 to be used in NestedCalls for testing nested calls
    public inline fun add_and_return_bytes(a: u8, b: u8): (u8, u8) {
        (a + b, a * b)
    }
}




//# run 0xCAFE::AddAndLambda::add_and_return --args 6u8 5u8



//# run 0xCAFE::AddAndLambda::compute_with_lambda --args 3u8 4u8



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndLambda;

    // Call an inline function from another module and then call a local function
    // Inline function f2 returns a tuple (u16, u16)
    public fun nested_inline_call_and_addition(a: u16, b: u16): u16 {
        let (val1, val2) = AddAndLambda::add_and_return_bytes(a as u8, b as u8);
        let sum_u16 = (val1 as u16) + (val2 as u16);
        sum_u16 + a + b
    }
}




//# run 0xCAFE::NestedCalls::nested_inline_call_and_addition --args 3u16 5u16
