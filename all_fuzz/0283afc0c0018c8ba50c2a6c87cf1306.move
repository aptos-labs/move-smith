
//# publish
module 0xCAFE::AddTest {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        lambda(7u8, 6u8)
    }
}


//# run 0xCAFE::AddTest::add_and_check --args 50u8 40u8


//# run 0xCAFE::AddTest::add_and_check --args 90u8 20u8


//# run 0xCAFE::AddTest::run_lambda_example



//# publish
module 0xCAFE::NestedInline {
    public inline fun base_increment(x: u8): u8 {
        x + 1
    }

    public fun call_base_increment(x: u8): u8 {
        base_increment(x)
    }

    public fun call_from_other_module(x: u8): u8 {
        0xCAFE::NestedInline::base_increment(x)
    }
}


//# publish
module 0xCAFE::CallerModule {
    public fun call_inline(x: u8): u8 {
        0xCAFE::NestedInline::call_base_increment(x)
    }

    public fun call_nested(x: u8): u8 {
        let y = 0xCAFE::NestedInline::base_increment(x);
        y + 1
    }
}


//# run 0xCAFE::NestedInline::call_base_increment --args 10u8


//# run 0xCAFE::NestedInline::call_from_other_module --args 20u8


//# run 0xCAFE::CallerModule::call_inline --args 30u8


//# run 0xCAFE::CallerModule::call_nested --args 40u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
