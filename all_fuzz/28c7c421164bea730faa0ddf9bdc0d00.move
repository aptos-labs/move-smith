
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}


//# publish
module 0xCAFE::AdditionAndLambda {
    // Test addition of two u8 values before returning a specific value

    public fun add_then_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        // Move currently does not support lambdas in all contexts, 
        // so we refactor to a regular function call instead of a closure
        Self::adder(x, y)
    }

    // Added explicit adder function to replace lambda usage
    public fun adder(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_func_nested(x: u16): (u16, u16) {
        // Calling inline function from 0xCAFE::MyModule
        0xCAFE::MyModule::f2(x)
    }

    public fun runner() {
        let _ = add_then_return_sum(10u8, 20u8);
        let _ = use_lambda(15u8, 25u8);
        let (_a, _b) = call_inline_func_nested(100u16);
    }
}


//# run 0xCAFE::AdditionAndLambda::add_then_return_sum --args 7u8 8u8


//# run 0xCAFE::AdditionAndLambda::use_lambda --args 12u8 13u8


//# run 0xCAFE::AdditionAndLambda::call_inline_func_nested --args 202u16


//# run 0xCAFE::AdditionAndLambda::runner


//# run
script {
    fun main() {
        let x: u8 = 33;
        let y: u8 = 44;
        // Replace lambda with direct function call
        let sum = 0xCAFE::AdditionAndLambda::adder(x, y);
        // Calling addition function from module directly
        let sum_from_module = 0xCAFE::AdditionAndLambda::add_then_return_sum(x, y);
        let (_a, _b) = 0xCAFE::AdditionAndLambda::call_inline_func_nested(300u16);
    }
}
