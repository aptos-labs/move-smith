
//# publish
module 0xCAFE::FuncAdd {
    public fun add_two_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus some constant 5u8 for checking correct addition and return
        sum + 5u8
    }
}



//# run 0xCAFE::FuncAdd::add_two_u8_values --args 10u8 20u8



//# publish
module 0xCAFE::LambdaTests {

    public fun apply_lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        lambda(x, y)
    }

    public fun nested_lambda() {
        let compose: |u8| (|u8| u8) has copy+drop = |a: u8| {
            let inner_lambda: |u8| u8 has copy+drop = |b: u8| { a + b };
            inner_lambda
        };
        let f = compose(5u8);
        let _result = f(10u8);
    }
}



//# run 0xCAFE::LambdaTests::apply_lambda_example --args 7u8 6u8



//# run 0xCAFE::LambdaTests::nested_lambda



//# publish
module 0xCAFE::InlineCaller {
    public fun f2(a: u16): (u16, u16) {
        // Provide the missing inline function f2 here
        (a, a + 1)
    }

    public fun call_inline(a: u16): u16 {
        let (p, q) = f2(a);
        p + q
    }
}



//# run 0xCAFE::InlineCaller::call_inline --args 20u16



//# publish
module 0xCAFE::FunctionParameter {
    // Function that takes a function parameter whose return type is a function
    public fun takes_fun_returning_fun(f: |u8| (|u8| u8)): u8 {
        let inner_fun = f(3u8);
        inner_fun(4u8)
    }

    public fun example_usage(): u8 {
        let lambda: |u8| (|u8| u8) has copy+drop = |x: u8| {
            let inner: |u8| u8 has copy+drop = |y: u8| {
                x + y
            };
            inner
        };
        takes_fun_returning_fun(lambda)
    }
}



//# run 0xCAFE::FunctionParameter::example_usage
