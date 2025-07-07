
//# publish
module 0xCAFE::NestedInline {
    // This module provides an inline function and a function calling it.

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add(a: u8, b: u8): u8 {
        inline_add(a, b)
    }
}



//# publish
module 0xCAFE::LambdaUsage {
    // This module showcases lambdas, their copy, and calls.

    public fun lambda_sum(x: u8, y: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        // Call lambda
        sum_lambda(x, y)
    }

    public fun lambda_identity(x: u8): u8 {
        let id_lambda: |u8| u8 has copy+drop = |a: u8| {
            a
        };
        id_lambda(x)
    }

    public fun lambda_copy_call(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        // Copy the lambda
        let f2 = copy f;
        f2(x, y)
    }
}



//# publish
module 0xCAFE::NumericFieldAndUse {
    // This module shows a struct with numeric fields and importing specific members.

    use 0xCAFE::LambdaUsage::{lambda_identity};

    struct Data has copy, drop, store {
        field0: u8, // replaced numeric field name with identifier
        field1: u8,
        field2: u8,
    }

    public fun make_data(a: u8, b: u8, c: u8): Data {
        Data {field0: a, field1: b, field2: c}
    }

    public fun use_lambda_identity(x: u8): u8 {
        lambda_identity(x)
    }
}



//# run 0xCAFE::NestedInline::call_inline_add --args 7u8 8u8



//# run 0xCAFE::LambdaUsage::lambda_sum --args 3u8 4u8



//# run 0xCAFE::LambdaUsage::lambda_identity --args 5u8



//# run 0xCAFE::LambdaUsage::lambda_copy_call --args 10u8 11u8



//# run 0xCAFE::NumericFieldAndUse::make_data --args 1u8 2u8 3u8



//# run 0xCAFE::NumericFieldAndUse::use_lambda_identity --args 42u8
