
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_result(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            7u8
        }
    }

    public fun lambda_example(x: u8, y: u8): (u8, u8) {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        let mul: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a * b;
        (add(x, y), mul(x, y))
    }

    public inline fun inline_sum(x: u8, y: u8): u8 {
        x + y
    }
}




//# run 0xCAFE::TestAdd::add_and_return_result --args 5u8 7u8



//# run 0xCAFE::TestAdd::add_and_return_result --args 3u8 4u8



//# run 0xCAFE::TestAdd::lambda_example --args 6u8 7u8



//# run 0xCAFE::TestAdd::lambda_example --args 3u8 5u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::TestAdd;

    public fun call_inline_sum(x: u8, y: u8): u8 {
        TestAdd::inline_sum(x, y)
    }
}



//# run 0xCAFE::NestedCall::call_inline_sum --args 8u8 9u8



//# run 0xCAFE::NestedCall::call_inline_sum --args 2u8 3u8



//# publish
module 0xCAFE::IfElseAssign {
    public fun assign_var(cond: bool): u8 {
        let x: u8;
        if (cond) {
            x = 10u8;
        } else {
            x = 20u8;
        };
        x
    }
}




//# run 0xCAFE::IfElseAssign::assign_var --args true



//# run 0xCAFE::IfElseAssign::assign_var --args false
