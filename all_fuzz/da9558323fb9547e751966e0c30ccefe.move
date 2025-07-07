
//# publish
module 0xCAFE::Addition {
    // Test that the Move function correctly computes the addition of two u8 values before returning a specific value.

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = if (sum > 10) { 10 } else { sum };
        result
    }

    public fun test_lambda() {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let _ = adder(4u8, 5u8);
    }

    public fun call_inline_add(a: u8, b: u8): u8 {
        add_inline(a, b)
    }

    public inline fun add_inline(x: u8, y: u8): u8 {
        x + y
    }
}



//# run 0xCAFE::Addition::add_and_return --args 7u8 8u8



//# run 0xCAFE::Addition::test_lambda



//# run 0xCAFE::Addition::call_inline_add --args 3u8 4u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Addition;

    public fun nested_inline_call(a: u8, b: u8): u8 {
        Addition::add_inline(a, b)
    }

    public fun nested_function_call(a: u8, b: u8): u8 {
        Addition::add_and_return(a, b)
    }
}



//# run 0xCAFE::NestedCall::nested_inline_call --args 2u8 3u8



//# run 0xCAFE::NestedCall::nested_function_call --args 6u8 5u8



//# publish
module 0xCAFE::MemberAlias {
    // Validate module member alias names to ensure they meet naming standards before usage.

    const VALID_ALIAS: u8 = 1;
    const HIDDEN_ALIAS: u8 = 2;

    public fun get_valid_alias(): u8 {
        VALID_ALIAS
    }

    public fun get_hidden_alias(): u8 {
        HIDDEN_ALIAS
    }
}



//# run 0xCAFE::MemberAlias::get_valid_alias



//# run 0xCAFE::MemberAlias::get_hidden_alias
