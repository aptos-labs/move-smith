
//# publish
module 0xCAFE::AdditionModule {
    // This module tests adding two u8 numbers and returning a specific value

    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum or 10 capped value
        if (sum > 10) {
            10u8
        } else {
            sum
        }
    }

    public fun test_lambda_function(x: u8): u8 {
        let lambda: |u8| u8 has copy + drop = |a: u8| {
            a + 2u8
        };
        lambda(x)
    }

    // Move language does NOT allow defining functions inside functions.
    // Define f2 as a private function at module level instead.
    fun f2(val: u16): (u16, u16) {
        (val, val * 2)  // simple example implementation
    }

    public fun test_inline_call(x: u16): u16 {
        let (a, b) = f2(x);
        a + b
    }

    public fun dummy_fun(): u8 {
        1u8
    }
}




//# run 0xCAFE::AdditionModule::add_two_numbers --args 4u8 5u8



//# run 0xCAFE::AdditionModule::test_lambda_function --args 7u8



//# run 0xCAFE::AdditionModule::test_inline_call --args 15u16
