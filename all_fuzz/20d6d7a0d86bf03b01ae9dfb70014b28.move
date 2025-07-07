
//# publish
module 0xCAFE::AdditionWithLambda {
    // Removed unused alias 'signer'

    public fun add_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    public fun run_lambda_example(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        lambda(x, y)
    }

    public fun run_lambda_and_add(x: u8, y: u8): u8 {
        let (sum, product) = run_lambda_example(x, y);
        let intermediate = sum + product;
        add_u8(intermediate, 0)
    }
}



//# publish
module 0xCAFE::NestedInlineCalls {
    use 0xCAFE::AdditionWithLambda;

    // Removed 'inline' keyword to avoid cross-module inline expansion error
    public fun inline_call_add(a: u8): u8 {
        let inner_result = AdditionWithLambda::add_u8(a, 1u8);
        inner_result + 2u8
    }

    public fun combined_call(x: u8, y: u8): u8 {
        let a = AdditionWithLambda::add_u8(x, y);
        let b = inline_call_add(x);
        a + b
    }

    public fun runner(): u8 {
        combined_call(3u8, 4u8)
    }
}



//# run 0xCAFE::AdditionWithLambda::add_u8 --args 10u8 32u8



//# run 0xCAFE::AdditionWithLambda::run_lambda_example --args 5u8 6u8



//# run 0xCAFE::AdditionWithLambda::run_lambda_and_add --args 3u8 4u8



//# run 0xCAFE::NestedInlineCalls::inline_call_add --args 7u8



//# run 0xCAFE::NestedInlineCalls::combined_call --args 2u8 3u8



//# run 0xCAFE::NestedInlineCalls::runner
