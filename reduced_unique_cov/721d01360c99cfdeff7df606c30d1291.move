
//# publish
module 0xCAFE::LambdaAndInline {
    // Test that Move function correctly computes addition of two u8 values before returning a specific value.
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        let ret = if (sum > 10) { 10u8 } else { sum };
        ret
    }

    // Write a function containing lambda (anonymous function) expressions.
    public fun use_lambda(x: u8, y: u8): u8 {
        let add: |u8, u8|u8 has copy + drop = |a: u8, b: u8| a + b;
        let result = add(x, y);
        result
    }

    // Define an inline function that returns a tuple for testing nested calls.
    public inline fun inline_fn_for_test(a: u16): (u16, u16) {
        (a + 2, a + 3)
    }

    // A public function that calls the inline function within the module
    public fun call_inline_fn(a: u16): u32 {
        let (p, q) = inline_fn_for_test(a);
        // Return the sum as u32 (u16 cast to u32)
        (p as u32) + (q as u32)
    }
}



//# publish
module 0xCAFE::CrossModuleCaller {
    use 0xCAFE::LambdaAndInline;

    // Call add_then_return in LambdaAndInline to verify addition works cross-module
    public fun call_add_then_return(x: u8, y: u8): u8 {
        LambdaAndInline::add_then_return(x, y)
    }

    // Call use_lambda function in LambdaAndInline to test lambda in another module
    public fun call_use_lambda(x: u8, y: u8): u8 {
        LambdaAndInline::use_lambda(x, y)
    }

    // Call the inline function in LambdaAndInline indirectly and compute sum
    public fun call_inline_fn_indirect(a: u16): u32 {
        LambdaAndInline::call_inline_fn(a)
    }
}



//# run 0xCAFE::LambdaAndInline::add_then_return --args 3u8 8u8



//# run 0xCAFE::LambdaAndInline::use_lambda --args 7u8 4u8



//# run 0xCAFE::LambdaAndInline::call_inline_fn --args 5u16



//# run 0xCAFE::CrossModuleCaller::call_add_then_return --args 2u8 5u8



//# run 0xCAFE::CrossModuleCaller::call_use_lambda --args 10u8 15u8



//# run 0xCAFE::CrossModuleCaller::call_inline_fn_indirect --args 7u16



//# run
script {
    use 0xCAFE::LambdaAndInline;

    fun main(): u8 {
        // Instead of `break result`, assign to a variable and return it after the loop
        let result: u8;
        loop {
            // Call add_then_return with 4u8 + 9u8 = 13, should return 10u8 (cap)
            result = LambdaAndInline::add_then_return(4u8, 9u8);
            // exit loop without break with value
            break;
        };
        result
    }
}
