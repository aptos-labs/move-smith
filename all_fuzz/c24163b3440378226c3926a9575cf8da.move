
//# publish
module 0xCAFE::TestAdd {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    public fun call_lambda_and_add(x: u8, y: u8): u8 {
        let f: |u8, u8|u8 has copy + drop = |m: u8, n: u8| {
            m + n
        };
        let result = f(x, y);
        result
    }

    public fun if_else_branch(flag: bool): u8 {
        if (flag) {
            100u8
        } else {
            200u8
        }
    }
}



//# run 0xCAFE::TestAdd::add_then_return_fixed --args 8u8 7u8



//# run 0xCAFE::TestAdd::call_lambda_and_add --args 10u8 20u8



//# run 0xCAFE::TestAdd::if_else_branch --args true



//# run 0xCAFE::TestAdd::if_else_branch --args false



//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::TestAdd;

    public inline fun inline_double_add(a: u8, b: u8): u8 {
        let partial_sum = a + b;
        let (x, y) = (partial_sum, partial_sum);
        // Call inline function if_else_branch from TestAdd which returns u8 via if-else
        let res = TestAdd::if_else_branch(true);
        res + x + y
    }

    public fun run_nested_calls(): u8 {
        let added = TestAdd::call_lambda_and_add(5u8, 15u8);
        let inline_result = inline_double_add(added, 10u8);
        inline_result
    }
}



//# run 0xCAFE::CallInline::run_nested_calls
