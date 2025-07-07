
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }
}



//# run 0xCAFE::TestAddition::add_and_return --args 5u8 7u8



//# publish
module 0xCAFE::LambdaExamples {
    public fun use_lambda_simple(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun use_lambda_with_capture(x: u8): u8 {
        let captured = 10u8;
        let lambda: |u8| u8 has copy+drop = |y: u8| {
            captured + y
        };
        lambda(x)
    }
}



//# run 0xCAFE::LambdaExamples::use_lambda_simple --args 3u8 4u8



//# run 0xCAFE::LambdaExamples::use_lambda_with_capture --args 5u8



//# publish
module 0xCAFE::InlineCall {

    public inline fun f2(x: u16): (u16, u16) {
        (x, x)
    }

    public inline fun inline_h1(x: u16): (u16, u16) {
        f2(x)
    }

    public fun nested_inline_call(x: u16): u16 {
        let (a, b) = inline_h1(x);
        a + b
    }
}



//# run 0xCAFE::InlineCall::nested_inline_call --args 15u16



//# publish
module 0xCAFE::OptionalTypeParameters {
    public fun generic_identity<T>(val: T): T {
        val
    }

    public fun call_generic_identity(): u8 {
        generic_identity<u8>(42u8)
    }
}



//# run 0xCAFE::OptionalTypeParameters::call_generic_identity



//# publish
module 0xCAFE::UninitializedVarTest {
    public fun check_uninitialized(x: u8, flag: bool): u8 {
        let val;
        if (flag) {
            return 99u8;
        } else {
            val = x + 1;
        };
        val
    }
}



//# run 0xCAFE::UninitializedVarTest::check_uninitialized --args 5u8 true



//# run 0xCAFE::UninitializedVarTest::check_uninitialized --args 5u8 false
