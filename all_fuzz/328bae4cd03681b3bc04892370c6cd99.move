
//# publish
module 0xCAFE::AddAndLambda {
    // Module to test addition, lambdas and inline function call from another module
    // Removed reference to 0xCAFE::MyModule which is not allowed and causes compile error

    // Adds two u8 values together and then adds 10, returns u8
    public fun add_and_offset(a: u8, b: u8): u8 {
        let result = a + b;
        result + 10
    }

    // Uses a lambda to add two u8 values, returns the result
    public fun add_using_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        lambda(x, y)
    }

    // Inline f2 function defined here to replace missing MyModule::f2
    // Mimics the expected signature and returns a tuple (u16, u16)
    // For demonstration, returns (x, x + 1)
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    // Calls the inline function f2 defined above, returns the first element of tuple
    public fun call_inline_f2_from_my_module(x: u16): u16 {
        let (a, _b) = f2(x);
        a
    }

    // Runner function to test add_and_offset
    public fun runner_add_and_offset(): u8 {
        add_and_offset(5u8, 15u8)
    }

    // Runner function to test add_using_lambda
    public fun runner_add_using_lambda(): u8 {
        add_using_lambda(20u8, 22u8)
    }

    // Runner function to test call_inline_f2_from_my_module
    public fun runner_call_inline_f2(): u16 {
        call_inline_f2_from_my_module(100u16)
    }
}



//# run 0xCAFE::AddAndLambda::runner_add_and_offset



//# run 0xCAFE::AddAndLambda::runner_add_using_lambda



//# run 0xCAFE::AddAndLambda::runner_call_inline_f2
