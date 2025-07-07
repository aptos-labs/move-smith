
//# publish
module 0xCAFE::FunctionTests {
    // This module focuses on testing function calls, lambdas, and inline functions

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun run_lambda(a: u8, b: u8): (u8, u8) {
        let anonymous_function: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        anonymous_function(a, b)
    }

    public inline fun inline_add(a: u16, b: u16): (u16, u16) {
        (a + b, a * b)
    }
}



//# publish
module 0xCAFE::CrossModuleCalls {
    use 0xCAFE::FunctionTests;

    public fun call_inline_add(a: u16, b: u16): (u16, u16) {
        // Call inline function from FunctionTests
        FunctionTests::inline_add(a, b)
    }

    public fun nested_calls(a: u16, b: u16): u16 {
        let (sum, product) = call_inline_add(a, b);
        sum + (product as u16)
    }
}



//# publish
module 0xCAFE::PatternBinding {
    use std::vector;

    struct Pair has copy, drop {
        a: u8,
        b: u8
    }

    public fun bind_list_example() {
        // We simulate bind_list conversion by manually binding elements from a vector
        let values = vector[1u8, 2u8, 3u8];
        let (a, b, c) = (vector::borrow(&values, 0), vector::borrow(&values, 1), vector::borrow(&values, 2));
        let _pa = *a;
        let _pb = *b;
        let _pc = *c;
    }
}



//# run 0xCAFE::FunctionTests::add_and_return_sum --args 4u8 5u8



//# run 0xCAFE::FunctionTests::run_lambda --args 2u8 3u8



//# run 0xCAFE::CrossModuleCalls::call_inline_add --args 5u16 6u16



//# run 0xCAFE::CrossModuleCalls::nested_calls --args 7u16 8u16



//# run 0xCAFE::PatternBinding::bind_list_example
