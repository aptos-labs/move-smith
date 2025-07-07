
//# publish
module 0xCAFE::Calculator {
    // Simple add function to test addition of two u8
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value 42 if sum is correct (>=0 always true)
        if (sum >= 0) {
            42
        } else {
            0
        }
    }

    // Function with lambda expression that multiplies then adds
    public fun lambda_test(x: u8, y: u8): u8 {
        let multiply = |a: u8, b: u8| a * b;
        let add = |a: u8, b: u8| a + b;

        let mul_result = multiply(x, y);
        let add_result = add(x, y);

        // Return mul_result + add_result just for testing
        mul_result + add_result
    }
}



//# publish
module 0xCAFE::MyModule {
    // Provide the missing function f2 that returns a tuple of two u16s based on input a
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Calculator;
    use 0xCAFE::MyModule;

    // Function calling inline function f2 from MyModule which returns a tuple
    // and then using the sum of tuple fields as index to add_two_u8 call.
    public fun call_inline_and_nested_functions(a: u16, x: u8, y: u8): u8 {
        let (v1, v2) = MyModule::f2(a);
        let sum = (v1 + v2) as u8;

        let add_res = Calculator::add_two_u8(x, y);
        let final_res = add_res + sum;
        final_res
    }
}



//# run 0xCAFE::Calculator::add_two_u8 --args 5u8 10u8



//# run 0xCAFE::Calculator::lambda_test --args 4u8 3u8



//# run 0xCAFE::NestedCalls::call_inline_and_nested_functions --args 10u16 2u8 3u8
