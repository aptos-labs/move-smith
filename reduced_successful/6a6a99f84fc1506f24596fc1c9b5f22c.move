
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_const(a: u8, b: u8): u8 {
        let _sum = a + b;
        let _lambda: |u8, u8| u8 = |x: u8, y: u8| { x + y };
        let _ = _lambda(a, b);
        42u8
    }

    // Changed the parameter type from |u8, u8| u8 to address::string::String
    public fun use_lambda_directly(_f_name: vector<u8>, a: u8, b: u8): u8 {
        // Since Move doesn't allow passing lambdas dynamically, 
        // you cannot pass a lambda as argument directly.
        // Instead, call the function directly here.

        // For demonstration, call add_and_return_const to simulate the function call.
        // Note: if you want other functions to be called dynamically, you need 
        // a different approach (e.g., dispatch table).

        // This simulates that _f_name corresponds to add_and_return_const
        add_and_return_const(a, b)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_const --args 5u8 10u8



//# run 0xCAFE::LambdaTest::use_lambda_directly --args "add_and_return_const" 7u8 8u8




//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::LambdaTest;

    public inline fun inline_add(a: u8, b: u8): u8 {
        let c = a + b;
        c
    }

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let x = LambdaTest::add_and_return_const(a, b);
        let y = inline_add(a, b);
        x + y
    }
}



//# run 0xCAFE::InlineCall::nested_inline_call --args 1u8 2u8
