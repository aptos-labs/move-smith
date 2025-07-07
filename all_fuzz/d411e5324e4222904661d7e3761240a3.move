
//# publish
module 0xCAFE::MyModule {
    // inline function f2 that returns a tuple (u16, u16)
    public inline fun f2(x: u16): (u16, u16) {
        // for example, return (x, x + 1)
        (x, x + 1u16)
    }
}


//# publish
module 0xCAFE::AddAndLambda {
    // Public function that adds two u8 values and returns the sum plus a constant
    public fun add_and_adjust(a: u8, b: u8): u8 {
        let sum = a + b;
        let adjusted = sum + 7u8;
        adjusted
    }

    // Private function using a lambda to multiply and then add
    fun multiply_and_add_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let product = a * b;
            let result = product + 10u8;
            result
        };
        lambda(x, y)
    }

    // Public function to demonstrate inline function call from another module
    public fun call_inline_from_other(x: u16): (u16, u16) {
        // calls 0xCAFE::MyModule::f2 inline function
        0xCAFE::MyModule::f2(x)
    }

    // Public function creating lambda with double-pipe syntax and using it
    public fun double_pipe_lambda_use(x: u8, y: u8): u8 {
        let lambda: || u8 has copy+drop = || {
            x + y
        };
        lambda()
    }

    // Public function regenerating and optimizing bytecode simulation by just performing some repeated code blocks
    public fun optimized_loop_compute(x: u8): u8 {
        let acc = 0u8;
        let i = 0u8;
        let mut_val = x;

        // simulate some optimization by looping and breaking early
        while (i < 10u8) {
            if (i == 5u8) {
                break;
            };
            acc = acc + i + mut_val;
            i = i + 1u8;
        };
        acc
    }
}



//# run 0xCAFE::AddAndLambda::add_and_adjust --args 12u8 23u8


//# run 0xCAFE::AddAndLambda::multiply_and_add_lambda --args 7u8 3u8


//# run 0xCAFE::AddAndLambda::call_inline_from_other --args 13u16


//# run 0xCAFE::AddAndLambda::double_pipe_lambda_use --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::optimized_loop_compute --args 4u8
