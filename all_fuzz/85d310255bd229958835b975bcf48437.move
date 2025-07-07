
//# publish
module 0xCAFE::AddAndLambda {
    // Module to test addition, lambdas and inline functions

    // Simple addition function using two u8 values, returns the sum + 1
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Function with a lambda expression that multiplies two u8 and adds a third
    public fun lambda_multiply_add(x: u8, y: u8, z: u8): u8 {
        let multiply = |a: u8, b: u8| a * b;
        let product = multiply(x, y);
        product + z
    }

    // Dummy inline-like function that returns a tuple of u16, u16
    // Since we cannot import from MyModule, provide a local function to simulate
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }

    // Call the local f2 and return sum of tuple elements as u32
    public fun call_inline_and_sum(a: u16): u32 {
        let (first, second) = f2(a);
        (first + second) as u32
    }

    // Runner to test nested function calls with no argument
    public fun runner() {
        let _ = add_and_increment(5u8, 7u8);
        let _ = lambda_multiply_add(3u8, 4u8, 2u8);
        let _ = call_inline_and_sum(10u16);
    }
}



//# run 0xCAFE::AddAndLambda::add_and_increment --args 100u8 27u8



//# run 0xCAFE::AddAndLambda::lambda_multiply_add --args 2u8 3u8 4u8



//# run 0xCAFE::AddAndLambda::call_inline_and_sum --args 20u16



//# run 0xCAFE::AddAndLambda::runner
