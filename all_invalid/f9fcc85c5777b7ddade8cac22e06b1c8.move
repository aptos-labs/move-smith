
//# publish
module 0xCAFE::TestAddAndLambda {
    use std::signer;

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
            OptU8::Some(mut v) => {
                // modify v inside this arm's scope
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


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 7fd23ef81200d0e183baf50ba0706177: Use match constructs with patterns that can bind variables, whose modifications are tracked within each arm's scope.
