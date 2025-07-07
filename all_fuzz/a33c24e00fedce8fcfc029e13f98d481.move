
//# publish
module 0xCAFE::AdditionLambda {

    public fun add_two_u8_and_return(u: u8, v: u8): u8 {
        let sum = u + v;
        // return a specific value, add sum and 10
        sum + 10
    }

    public fun run_lambda_example(x: u8, y: u8): u8 {
        // lambda adds, then multiplies
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let add = a + b;
            let mul = a * b;
            add + mul
        };
        lambda(x, y)
    }

    public fun f2(x: u16): (u16, u16) {
        // provide a simple inline function inside this module 
        // that returns a tuple (x, x)
        (x, x)
    }

    public fun call_inline_f2(x: u16): u16 {
        let (a, b) = f2(x);
        a + b
    }

    public fun runner_without_args() {
        let _ = add_two_u8_and_return(2u8, 3u8);
        let _ = run_lambda_example(4u8, 5u8);
        let _ = call_inline_f2(10u16);
    }
}



//# run 0xCAFE::AdditionLambda::add_two_u8_and_return --args 7u8 8u8



//# run 0xCAFE::AdditionLambda::run_lambda_example --args 3u8 5u8



//# run 0xCAFE::AdditionLambda::call_inline_f2 --args 20u16



//# run 0xCAFE::AdditionLambda::runner_without_args
