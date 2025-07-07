
//# publish
module 0xCAFE::AddAndLambda {
    // Define the MyModule inline function here to fix the missing reference
    // Since f2 returns a tuple, define a struct for its return type (tuples aren't allowed as locals)
    // Add the 'drop' ability to TupleU16 or consume the value to fix the drop error
    // Here we consume the value by unpacking it
    struct TupleU16 {
        a: u16,
        b: u16,
    }

    // Mark as public so can be called from use_inline_and_lambda
    public fun f2(x: u16): TupleU16 {
        // Dummy example logic: split x into two parts
        // For example: a = x / 2, b = x - a
        let a = x / 2;
        let b = x - a;
        TupleU16 { a, b }
    }

    public fun add_and_check(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 250) {
            250u8
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        add_lambda(x, y)
    }

    public fun use_inline_and_lambda(x: u8, y: u8): u16 {
        // Call inline function defined above in this module
        // Consume inline_res by unpacking it (to avoid drop errors)
        let inline_res = 0xCAFE::AddAndLambda::f2((x as u16) + (y as u16));
        let 0xCAFE::AddAndLambda::TupleU16 { a, b } = inline_res;
        let multiplier_lambda: |u16| u16 has copy+drop = |v: u16| { v * 2 };
        multiplier_lambda(a + b)
    }
}



//# run 0xCAFE::AddAndLambda::add_and_check --args 100u8 150u8



//# run 0xCAFE::AddAndLambda::lambda_example --args 10u8 20u8



//# run 0xCAFE::AddAndLambda::use_inline_and_lambda --args 5u8 10u8
