
//# publish
module 0xCAFE::AdvancedTest {
    use std::signer;

    // 1. Test addition of two u8 values and a fixed return
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        assert!(sum <= 255, 1000);
        42u8
    }

    // 2. Lambda expressions and usage
    public fun apply_lambda_to_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun lambda_in_lambda(x: u8, y: u8): u8 {
        let outer_lambda: |u8, u8| |u8|u8 has copy + drop = |a: u8, b: u8| {
            let inner_lambda: |u8| u8 has copy + drop = |c: u8| {
                a + b + c
            };
            inner_lambda
        };
        let inner_f = outer_lambda(x, y);
        inner_f(1u8)
    }

    // 3. Calling inline function in another module with nested calls
    // This module assumes 0xCAFE::MyModule is published and accessible
    public fun call_my_module_f2(input: u16): (u16, u16) {
        0xCAFE::MyModule::f2(input)
    }

    // 5. Specification block with multiple members for the function
    spec add_and_return_sum {
        // Label: sum computed
        let sum = a + b;
        assert!(sum <= 255, 1000);
    }

    spec apply_lambda_to_add {
        let res = apply_lambda_to_add(a, b);
        assert!(res == a + b, 1001);
    }
}


//# run 0xCAFE::AdvancedTest::add_and_return_sum --args 15u8 20u8


//# run 0xCAFE::AdvancedTest::apply_lambda_to_add --args 7u8 8u8


//# run 0xCAFE::AdvancedTest::lambda_in_lambda --args 10u8 12u8


//# run 0xCAFE::AdvancedTest::call_my_module_f2 --args 123u16

// Additional // test] style annotation simulation (this is just a comment since Move doesn't support attributes)
// These can be used in Move testing frameworks that parse comments for config

// // test(key="value", number=123)]
// fn example_test() {
//   // Test code here
// }

// In this transactional test environment, we place the "tests" as above run commands.


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4499b330abccc6affd4408051b340799: Manage module context during compilation to ensure correct referencing and isolation.
// 5f9dc68e4856a3771547bd240e8f920b: Define specification blocks with multiple members using `spec_block`.
// 49b7a8368d3cf383a8162ffa3806d4f6: Annotate tests with #[test] attributes that can take key-value pairs with literal values for test configuration.
