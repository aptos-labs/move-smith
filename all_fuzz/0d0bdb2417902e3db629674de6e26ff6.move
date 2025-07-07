
//# publish
module 0xCAFE::Adder {
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 10) {
            42u8
        } else {
            sum
        }
    }

    public fun use_lambda_to_add(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun runner(): u8 {
        use_lambda_to_add(3u8, 7u8)
    }

    // Move requires function to be public for cross-module calls
    public inline fun inline_helper(a: u16): (u16, u16) {
        (a + 10, a + 20)
    }
}



//# run 0xCAFE::Adder::add_and_return_special --args 3u8 4u8



//# run 0xCAFE::Adder::add_and_return_special --args 5u8 5u8



//# run 0xCAFE::Adder::use_lambda_to_add --args 10u8 20u8



//# run 0xCAFE::Adder::runner



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Adder;

    public fun call_adder_runner(): u8 {
        Adder::runner()
    }

    public fun call_adder_inline(x: u16): (u16, u16) {
        Adder::inline_helper(x)
    }

    public fun call_adder_inline_through_another(x: u16): (u16, u16) {
        let (p, q) = Adder::inline_helper(x);
        (p + 1, q + 1)
    }
}



//# run 0xCAFE::NestedCall::call_adder_runner



//# run 0xCAFE::NestedCall::call_adder_inline --args 7u16



//# run 0xCAFE::NestedCall::call_adder_inline_through_another --args 7u16


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
