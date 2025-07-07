
//# publish
module 0xCAFE::MyModule {
    // Removed `mut` from parameter as it's not allowed in Move function signatures
    /// f2 takes a u16 and returns a tuple of two u16 values
    public fun f2(x: u16): (u16, u16) {
        // Let's assume it returns (x, x + 1)
        (x, x + 1)
    }

    /// f1 takes a u8 and a bool, adding until >= 10 and then +1
    public fun f1(x: u8, flag: bool): u8 {
        // If flag is true, loop adding 1 until x >= 10, then add 1 more
        // Otherwise, just returns x
        let x_mut = x;
        if (flag) {
            while (x_mut < 10) {
                x_mut = x_mut + 1;
            };
            x_mut + 1
        } else {
            x_mut
        }
    }
}


//# publish
module 0xCAFE::LambdaAdd {
    // Test addition of two u8 and return a fixed value

    // Lambda that adds two u8 values and returns the result
    public fun add_two_u8(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let _sum = add_lambda(a, b);
        42u8
    }

    // Another function with a lambda that doubles the input
    public fun double_input(x: u8): u8 {
        let double_lambda: |u8| u8 has copy+drop = |v: u8| {
            v * 2u8
        };
        double_lambda(x)
    }

    // Calling inline functions defined in another module 
    // and combining their results
    public fun nested_calls(x: u16): u32 {
        // call inline function f2 from 0xCAFE::MyModule which returns (u16,u16)
        let (a, b) = 0xCAFE::MyModule::f2(x);
        // Call f1 which adds until >=10 and then +1
        let c = 0xCAFE::MyModule::f1(a as u8, true);
        (b as u32) + (c as u32)
    }

    // Function to demonstrate elimination of unreachable code and dead stores
    public fun optimized_code(x: u8): u8 {
        // No unused variables or unreachable code here
        if (x > 10) {
            100u8
        } else {
            200u8
        };
        // The last expression is the return value in Move functions
        if (x > 5) {
            1u8
        } else {
            2u8
        }
    }
}


//# run 0xCAFE::LambdaAdd::add_two_u8 --args 3u8 4u8


//# run 0xCAFE::LambdaAdd::double_input --args 6u8


//# run 0xCAFE::LambdaAdd::nested_calls --args 7u16


//# run 0xCAFE::LambdaAdd::optimized_code --args 12u8


//# run 0xCAFE::LambdaAdd::optimized_code --args 3u8
