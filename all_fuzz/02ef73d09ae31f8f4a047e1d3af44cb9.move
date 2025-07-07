
//# publish
module 0xCAFE::AddModule {
    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        let c = 42u8;
        // Return c regardless of sum, testing basic addition calculation internally
        c
    }

    public fun get_lambda(): |u8, u8| u8 has copy + drop {
        |x: u8, y: u8| {
            x + y
        }
    }

    public fun call_lambda_with_constants(): u8 {
        let lambda = get_lambda();
        lambda(10u8, 32u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add_and_double(a: u8, b: u8): u8 {
        let s = inline_add(a, b);
        s * 2u8
    }
}


//# run 0xCAFE::AddModule::add_two_numbers --args 7u8 8u8


//# run 0xCAFE::AddModule::call_lambda_with_constants


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_add_and_return_double(a: u8, b: u8): u8 {
        let sum = AddModule::inline_add(a, b);
        sum * 2u8
    }

    public fun call_lambda_via_addmodule(): u8 {
        let lambda = AddModule::get_lambda();
        lambda(3u8, 4u8)
    }
}


//# run 0xCAFE::CallerModule::call_add_and_return_double --args 5u8 6u8


//# run 0xCAFE::CallerModule::call_lambda_via_addmodule


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
