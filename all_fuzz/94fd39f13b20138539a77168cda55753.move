
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u8, u8) {
        // Sample implementation returning two u8 values derived from x
        let a = (x & 0x00FF) as u8; // lower 8 bits
        let b = ((x >> 8) & 0x00FF) as u8; // higher 8 bits
        (a, b)
    }
}

//# publish
module 0xCAFE::AdditionAndLambda {
    // Removed unused import std::vector

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;

        // Return sum + 10, just an arbitrary transformation to test computations
        sum + 10
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };

        add(x, y)
    }

    public fun call_inline_and_lambda(x: u16): u8 {
        // Call inline function from MyModule to get a tuple
        let (a, b) = 0xCAFE::MyModule::f2(x);

        // Use lambda to add the two values casted to u8
        let add_lambda: |u8, u8| u8 has copy+drop = |i: u8, j: u8| {
            i + j
        };

        add_lambda(a as u8, b as u8)
    }
}



//# run 0xCAFE::AdditionAndLambda::add_and_return_sum --args 5u8 7u8


//# run 0xCAFE::AdditionAndLambda::lambda_example --args 12u8 30u8


//# run 0xCAFE::AdditionAndLambda::call_inline_and_lambda --args 15u16
