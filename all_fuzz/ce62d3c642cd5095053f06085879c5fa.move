
//# publish
module 0xCAFE::MathAndLambda {
    // Module to test arithmetic and lambda functions

    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 10) {
            42u8
        } else {
            sum
        }
    }

    public fun lambda_identity(x: u8): u8 {
        let identity: |u8|u8 has copy+drop = |a: u8| { a };
        identity(x)
    }

    public fun lambda_double_then_add(x: u8, y: u8): u8 {
        let double: |u8|u8 has copy+drop = |a: u8| { a + a };
        let add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        add(double(x), y)
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::MathAndLambda;

    // <-- inline removed here
    public fun call_inline(x: u8, y: u8): u8 {
        MathAndLambda::add_and_return_special(x, y)
    }

    public fun nested_inline_call(x: u8, y: u8): u8 {
        let intermediate = call_inline(x, y);
        MathAndLambda::lambda_double_then_add(intermediate, y)
    }

    public fun runner(): u8 {
        nested_inline_call(3u8, 4u8)
    }
}



//# run 0xCAFE::MathAndLambda::add_and_return_special --args 4u8 6u8



//# run 0xCAFE::MathAndLambda::add_and_return_special --args 2u8 3u8



//# run 0xCAFE::MathAndLambda::lambda_identity --args 7u8



//# run 0xCAFE::MathAndLambda::lambda_double_then_add --args 5u8 3u8



//# run 0xCAFE::InlineCaller::call_inline --args 5u8 5u8



//# run 0xCAFE::InlineCaller::nested_inline_call --args 3u8 4u8



//# run 0xCAFE::InlineCaller::runner
