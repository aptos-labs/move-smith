
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10u8;
        result
    }

    public fun lambda_test(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let inline_sum = AdditionModule::inline_add(a, b);
        let lambda_sum = AdditionModule::lambda_test(inline_sum, 1u8);
        lambda_sum
    }
}


//# run
script {
    use 0xCAFE::AdditionModule;
    use 0xCAFE::NestedCallModule as NCM;

    fun main() {
        let a = 5u8;
        let b = 7u8;
        let result_add = AdditionModule::add_two_numbers(a, b);
        let result_lambda = AdditionModule::lambda_test(a, b);
        let result_nested = NCM::call_inline_and_lambda(a, b);

        let seq = 2u8;
        seq = seq + 3u8;
        let seq_result = seq + 5u8;

        // To clearly separate these results in the test runtime
        let _: u8 = result_add;
        let _: u8 = result_lambda;
        let _: u8 = result_nested;
        let _: u8 = seq_result;
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c60e0dacdbbbb99a118f95e2c9f730c0: Use 'uses' declarations to bring modules or functions into script scope (using aliases).
// 47a2fb680c8ad45b47ce3cbb8cb7ce80: Define and use comma-separated lists of items (such as function parameters, struct fields, or type arguments) in Move source code.
// f5d85ae3cb5ae9c572071bd106e8a755: Test that the Move function correctly performs sequential assignments and uses the updated value in an arithmetic operation.
