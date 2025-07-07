
//# publish
module 0xCAFE::TestAddAndLambda {
    // Removed unused import `std::signer`
    // use std::signer;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_return_const(a: u8, b: u8): u8 {
        let sum = inline_add(a, b);
        // Return 42 regardless of sum
        42u8
    }

    public fun lambda_double_and_add(x: u8, y: u8): u8 {
        let double = |v: u8| { v * 2 };
        let sum = double(x) + y;
        sum
    }

    public fun lambda_with_captured(x: u8): u8 {
        let add_x = |v: u8| { v + x };
        add_x(10)
    }
}



//# run 0xCAFE::TestAddAndLambda::add_and_return_const --args 10u8 32u8



//# run 0xCAFE::TestAddAndLambda::lambda_double_and_add --args 3u8 4u8



//# run 0xCAFE::TestAddAndLambda::lambda_with_captured --args 7u8




//# publish
module 0xCAFE::TestNestedInlineMatch {
    use 0xCAFE::TestAddAndLambda;

    enum OptU8 has copy, drop {
        None,
        Some(u8)
    }

    public fun nested_inline_and_match(opt: OptU8): u8 {
        match (opt) {
            OptU8::None => {
                // Calls inline_add from another module
                TestAddAndLambda::inline_add(1u8, 2u8)
            },
            OptU8::Some(v) => {
                // modify v inside this arm's scope
                let v = v;
                v = v + 1;
                // Call inline_add with modified v and constant 5u8
                let result = TestAddAndLambda::inline_add(v, 5u8);
                // Return result
                result
            }
        }
    }

    public fun runner_no_args(): u8 {
        let r1 = nested_inline_and_match(OptU8::None);
        let r2 = nested_inline_and_match(OptU8::Some(10u8));
        r1 + r2
    }
}



//# run 0xCAFE::TestNestedInlineMatch::nested_inline_and_match --args 0u8



//# run 0xCAFE::TestNestedInlineMatch::nested_inline_and_match --args 11u8



//# run 0xCAFE::TestNestedInlineMatch::runner_no_args
