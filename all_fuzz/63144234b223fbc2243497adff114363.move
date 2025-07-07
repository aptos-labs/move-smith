
//# publish
module 0xCAFE::NestedInline {
    // Module to test nested inline function calls

    public inline fun inner_inline(a: u16): u16 {
        a + 100
    }

    public fun caller_inline(x: u16): u16 {
        inner_inline(x) + 5
    }
}




//# publish
module 0xCAFE::Computation {
    // Module to test basic computation and inline function calls

    public inline fun add_two_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_and_return(a: u8, b: u8): u8 {
        let sum = add_two_u8(a, b);
        // Return the sum + 5 just as a test of computation
        sum + 5
    }

    public fun apply_lambda_and_add(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = lambda(x, y);
        result + 1u8
    }

    public fun move_and_consume(mut_val: u8): u8 {
        let val1 = mut_val;
        // Move val1 out - no re-use of val1 allowed afterward
        let val2 = val1;
        val2 + 10u8
    }

    public fun call_inline_from_other_module(x: u16): u16 {
        0xCAFE::NestedInline::caller_inline(x)
    }
}




//# run 0xCAFE::Computation::compute_and_return --args 3u8 4u8




//# run 0xCAFE::Computation::apply_lambda_and_add --args 7u8 8u8




//# run 0xCAFE::Computation::move_and_consume --args 12u8




//# run 0xCAFE::Computation::call_inline_from_other_module --args 10u16
