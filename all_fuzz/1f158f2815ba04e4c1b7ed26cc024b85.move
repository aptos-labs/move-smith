
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_specific_value(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a specific value for test: sum + 10
        sum + 10
    }
}



//# run 0xCAFE::TestAddition::add_and_return_specific_value --args 3u8 7u8



//# publish
module 0xCAFE::TestLambda {
    public fun run_lambda_no_args() {
        let lambda: || u8 has copy+drop = || {
            42u8
        };
        let _result = lambda();
    }

    public fun run_lambda_with_args(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::TestLambda::run_lambda_no_args



//# run 0xCAFE::TestLambda::run_lambda_with_args --args 6u8 7u8



//# publish
module 0xCAFE::TestInlineCall {
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add_and_compute(x: u8, y: u8): u8 {
        let sum = Self::inline_add(x, y);
        sum * 2
    }
}



//# run 0xCAFE::TestInlineCall::call_inline_add_and_compute --args 5u8 10u8



//# publish
module 0xCAFE::TestStructEnum {
    struct Point has copy, drop, store {
        x: u8,
        y: u8,
    }

    enum Status has copy, drop {
        Init,
        Running(u8),
        Stopped { reason: u8 },
    }

    public fun create_point_and_status(x: u8, y: u8, status_code: u8): (Point, Status) {
        let p = Point { x, y };
        let s = if (status_code == 0) {
            Status::Init
        } else if (status_code < 10) {
            Status::Running(status_code)
        } else {
            Status::Stopped { reason: status_code }
        };
        (p, s)
    }

    public fun use_default_return_type(x: u8) {
        let _ = x + 1;
    }
}



//# run 0xCAFE::TestStructEnum::create_point_and_status --args 3u8 4u8 5u8



//# run 0xCAFE::TestStructEnum::use_default_return_type --args 10u8
