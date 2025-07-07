
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return 42 if sum equals 42, otherwise return sum
        if (sum == 42) {
            42
        } else {
            sum
        }
    }
}



//# run 0xCAFE::AddAndReturn::add_and_check --args 20u8 22u8



//# publish
module 0xCAFE::LambdaExamples {
    public fun apply_lambda(a: u8, b: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        f(a, b)
    }

    public fun use_lambda_within_lambda(x: u8): u8 {
        let outer_lambda: |u8| u8 has copy+drop = |y: u8| {
            let inner_lambda: |u8| u8 has copy+drop = |z: u8| {
                y + z
            };
            inner_lambda(x)
        };
        outer_lambda(x)
    }
}



//# run 0xCAFE::LambdaExamples::apply_lambda --args 6u8 7u8



//# run 0xCAFE::LambdaExamples::use_lambda_within_lambda --args 5u8



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndReturn;

    public fun nested_call(a: u8, b: u8): u8 {
        let val = AddAndReturn::add_and_check(a, b);
        val + 1
    }

    public fun runner(): u8 {
        nested_call(20, 21)
    }
}



//# run 0xCAFE::NestedCalls::nested_call --args 10u8 32u8



//# run 0xCAFE::NestedCalls::runner
