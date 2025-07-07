
//# publish
module 0xCAFE::Calculator {
    public fun add_u8(a: u8, b: u8): u8 {
        // Unused variable warning removed by prefixing with underscore
        let _sum = a + b;
        // test returns a fixed value after calculation
        42u8
    }

    public fun apply_lambda(a: u8, b: u8): u8 {
        // lambda that sums two u8 numbers and returns the sum
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        lambda(a, b)
    }

    public fun apply_lambda_then_add_one(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        let result = lambda(a, b);
        result + 1u8
    }
}

// You need to define 0xCAFE::MyModule with function f2 because NestedCaller depends on it


//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        // Return two values derived from a just for the example
        (a, a * 2)
    }
}



//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::Calculator;

    public fun call_inline_then_lambda(a: u16, b: u16): (u16, u16, u8) {
        // call the inline function f2 from MyModule
        let (x, y) = 0xCAFE::MyModule::f2(a);
        // call a lambda function here that adds the two u16 values cast to u8 (saturate by truncation)
        let lambda: |u8, u8| u8 has copy+drop = |x, y| { x + y };
        let sum_u8 = lambda(x as u8, y as u8);
        // also call Calculator::apply_lambda_then_add_one with the sum_u8 and b cast to u8
        let calculator_result = Calculator::apply_lambda_then_add_one(sum_u8, b as u8);
        (x, y, calculator_result)
    }

    public fun runner(): (u16, u16, u8) {
        call_inline_then_lambda(10u16, 20u16)
    }
}



//# run 0xCAFE::Calculator::add_u8 --args 3u8 5u8



//# run 0xCAFE::Calculator::apply_lambda --args 7u8 8u8



//# run 0xCAFE::Calculator::apply_lambda_then_add_one --args 7u8 8u8



//# run 0xCAFE::NestedCaller::runner
