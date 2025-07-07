
//# publish
module 0xCAFE::Addition {
    const MAGIC_NUMBER: u8 = 42;

    public fun add_and_return_magic(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            MAGIC_NUMBER
        } else {
            sum
        }
    }

    // Move currently does not support lambda syntax, so convert to a normal function instead
    public fun add(x: u8, y: u8): u8 {
        x + y
    }

    public fun lambda_adder(): u8 {
        // use the named function add instead of lambda
        Self::add(10, 15)
    }

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }
}



//# run 0xCAFE::Addition::add_and_return_magic --args 50u8 60u8



//# run 0xCAFE::Addition::add_and_return_magic --args 10u8 20u8



//# run 0xCAFE::Addition::lambda_adder



//# publish
module 0xCAFE::ComplexUsage {
    use 0xCAFE::Addition;

    public fun use_inline_and_lambda(x: u8, y: u8): u8 {
        let double_y = Addition::inline_double(y);
        // similarly, replace the lambda with a named local helper function or inline code
        // here, anonymous functions are not supported, so we inline the addition:
        let adder_result = x + double_y;
        adder_result
    }

    public fun runner(): u8 {
        use_inline_and_lambda(5u8, 10u8)
    }
}



//# run 0xCAFE::ComplexUsage::use_inline_and_lambda --args 3u8 6u8



//# run 0xCAFE::ComplexUsage::runner
