
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 10) {
            42
        } else {
            0
        }
    }

    public fun run_example(): u8 {
        add_and_return_special(4, 6)
    }
}


//# run 0xCAFE::TestAddition::add_and_return_special --args 3u8 7u8


//# run 0xCAFE::TestAddition::add_and_return_special --args 1u8 2u8


//# run 0xCAFE::TestAddition::run_example


//# publish
module 0xCAFE::TestLambda {
    public fun apply_lambda_to_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a * 2
        };
        lambda(sum)
    }

    public fun nested_lambda(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let mul_by_two: |u8| u8 has copy+drop = |v: u8| {
            2 * v
        };
        let sum = add(x, y);
        mul_by_two(sum)
    }
}


//# run 0xCAFE::TestLambda::apply_lambda_to_sum --args 3u8 5u8


//# run 0xCAFE::TestLambda::nested_lambda --args 4u8 6u8


//# publish
module 0xCAFE::TestInlineCaller {
    use 0xCAFE::TestAddition;

    public fun call_inline_add_and_check(x: u8, y: u8): u8 {
        let result = TestAddition::add_and_return_special(x, y);
        result
    }

    public fun call_run_example(): u8 {
        TestAddition::run_example()
    }
}


//# run 0xCAFE::TestInlineCaller::call_inline_add_and_check --args 5u8 5u8


//# run 0xCAFE::TestInlineCaller::call_inline_add_and_check --args 1u8 2u8


//# run 0xCAFE::TestInlineCaller::call_run_example


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
