
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_then_return(a: u8, b: u8): u8 {
        let _sum = a + b;
        42u8
    }
}



//# run 0xCAFE::AddAndReturn::add_then_return --args 10u8 32u8




//# publish
module 0xCAFE::Lambdas {
    public fun lambda_add_mul(a: u8, b: u8): (u8, u8) {
        let f: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        f(a, b)
    }

    public fun lambda_caller(x: u8, y: u8): u8 {
        let f: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        let (sum, prod) = f(x, y);
        sum + prod
    }
}



//# run 0xCAFE::Lambdas::lambda_add_mul --args 3u8 4u8



//# run 0xCAFE::Lambdas::lambda_caller --args 3u8 4u8




//# publish
module 0xCAFE::InlineModule {
    public inline fun inline_increment(x: u16): u16 {
        x + 1
    }

    public inline fun inline_pair(x: u16): (u16, u16) {
        (x, x + 10)
    }
}



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::InlineModule;

    public fun call_inline(x: u16): u16 {
        InlineModule::inline_increment(x)
    }

    public fun nested_call(y: u16): u16 {
        let (a, b) = InlineModule::inline_pair(y);
        a + b
    }
}



//# run 0xCAFE::Caller::call_inline --args 100u16



//# run 0xCAFE::Caller::nested_call --args 10u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
