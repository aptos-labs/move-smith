
//# publish
module 0xCAFE::AdditionModule {
    // Module to test addition of two u8 values and return a specific value
    public fun add_then_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 42) {
            100u8
        } else {
            sum
        }
    }
    
    public fun caller_lambda(x: u8, y: u8): (u8, u8) {
        let add = |a: u8, b: u8| {
            a + b
        };
        let mul = |a: u8, b: u8| {
            a * b
        };
        (add(x, y), mul(x, y))
    }
    
    public fun test_lambda_stored(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + (b * 2)
        };
        lambda(3u8, 4u8)
    }
}


//# run 0xCAFE::AdditionModule::add_then_return_special --args 40u8 2u8


//# run 0xCAFE::AdditionModule::caller_lambda --args 3u8 4u8


//# run 0xCAFE::AdditionModule::test_lambda_stored



//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AdditionModule::add_then_return_special(a, b)
    }

    public fun call_inline_from_other(x: u8, y: u8): u8 {
        inline_add(x, y)
    }
}


//# run 0xCAFE::InlineCallModule::call_inline_from_other --args 20u8 22u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
