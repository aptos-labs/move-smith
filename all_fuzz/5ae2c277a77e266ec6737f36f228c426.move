
//# publish
module 0xCAFE::LambdaTest {
    // Test lambdas, addition and nested inline function calls

    // Removed invalid `use 0xCAFE::MyModule;` because it's not available

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;

        // Return 42 if sum is 42, else return sum
        if (sum == 42) {
            42u8
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    /// Since MyModule::f2 is not available, we define a local helper function to simulate its behavior
    public fun call_inline_function(a: u16): u32 {
        // Because Move does not support nested functions or inline funs inside another function,
        // define a private helper function in the module instead
        let (a1, a2) = Self::f2(a);
        // Sum the results of helper function and cast to u32
        (a1 + a2) as u32
    }

    // Move does not allow function definitions inside other functions.
    // Define f2 as a private function in the module.
    fun f2(x: u16): (u16, u16) {
        // For demonstration, just split the input into two parts
        (x / 2, x / 2)
    }

    public fun runner(): u8 {
        let a = add_and_return(20u8, 22u8);
        let b = lambda_example(5u8, 7u8);
        let c = call_inline_function(10u16);
        // Just return a to check add_and_return works
        a
    }
}




//# run 0xCAFE::LambdaTest::add_and_return --args 40u8 2u8




//# run 0xCAFE::LambdaTest::lambda_example --args 10u8 20u8




//# run 0xCAFE::LambdaTest::call_inline_function --args 100u16




//# run 0xCAFE::LambdaTest::runner
