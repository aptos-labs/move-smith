
//# publish
module 0xCAFE::MathLambda {

    // Define the f2 function here to replace MyModule::f2 call
    public fun f2(a: u16): (u16, u16) {
        // For example, return (a, a+1)
        (a, a + 1)
    }

    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        f(x, y)
    }

    public fun nested_call_inline(a: u16): u16 {
        let (x, y) = f2(a);
        x + y
    }

    public fun no_arg_runner(): u8 {
        let l: |u8| u8 has copy+drop = |x: u8| { x + 5u8 };
        let res = add_then_return(3u8, 7u8);
        let lambda_res = apply_lambda(2u8, 6u8);
        let nested_res = nested_call_inline(10u16);
        l(10u8) + res + lambda_res + (nested_res as u8)
    }
}



//# run 0xCAFE::MathLambda::add_then_return --args 5u8 10u8



//# run 0xCAFE::MathLambda::apply_lambda --args 3u8 7u8



//# run 0xCAFE::MathLambda::nested_call_inline --args 5u16



//# run 0xCAFE::MathLambda::no_arg_runner
