
//# publish
module 0xCAFE::LambdaTest {
    use std::vector;
    use 0xCAFE::MyModule;

    const ABORT_CODE_1: u64 = 100u64;
    const ABORT_CODE_2: u64 = 200u64;

    public fun lambda_caller(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| a + b;
        let result = add_lambda(x, y);

        // Test calling another lambda returned inline function
        let inline_result = self::call_inline_lambda_with(my_inline_function, result);

        if (inline_result == 0u8) {
            abort ABORT_CODE_1;
        };

        inline_result
    }

    public inline fun my_inline_function(a: u8): u8 {
        // nested if with number without :: after it
        if (a == 0u8) {
            0u8
        } else {
            a + 1u8
        }
    }

    public fun call_inline_lambda_with(lambda: |u8|u8, input: u8): u8 {
        lambda(input)
    }

    // FIXED: The parameter pattern "(a, b): (u8, u8)" was invalid in lambda parameters.
    // Instead, declare the parameter as a single tuple variable and destructure inside the body.
    public fun pipe_lambda(x: u8): u8 {
        let lambda_with_bindings: |(u8, u8), bool|u8 has copy+drop = 
            |p: (u8, u8), flag: bool| {
                let a = p.0;
                let b = p.1;

                if (flag) {
                    a + b
                } else {
                    a * b
                }
            };
        lambda_with_bindings((x, 2u8), true)
    }

    public fun abort_if_even(x: u8) acquires u8 {
        if ((x % 2u8) == 0u8) {
            abort ABORT_CODE_2;
        };
    }
}



//# run 0xCAFE::LambdaTest::lambda_caller --args 4u8 5u8


//# run 0xCAFE::LambdaTest::pipe_lambda --args 7u8


//# run 0xCAFE::LambdaTest::abort_if_even --args 3u8


//# run 0xCAFE::LambdaTest::abort_if_even --args 4u8
