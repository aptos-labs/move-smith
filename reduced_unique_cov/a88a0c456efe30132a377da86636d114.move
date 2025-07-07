
//# publish
module 0xCAFE::TestModule1 {
    // Test feature 1: compute addition of two u8 before returning a fixed value
    public fun add_then_return_fixed(_a: u8, _b: u8): u8 {
        // let sum = a + b; // removed to avoid unused binding warning
        // ignore sum and always return 42
        42u8
    }

    // Test feature 2: function with lambda expressions that returns (sum, product)
    public fun lambda_sum_product(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        lambda(a, b)
    }

    // Internal function for feature 4
    fun foo(p: u8, _flag: bool): u8 {
        p
    }

    // Test feature 4: verify foo returns p regardless of boolean flag
    public fun test_foo(p: u8) {
        let result_true = foo(p, true);
        let result_false = foo(p, false);
        assert!(result_true == p, 1234);
        assert!(result_false == p, 1234);
    }
}




//# publish
module 0xCAFE::TestModule2 {
    use 0xCAFE::TestModule1;

    // Test feature 3: call inline function from TestModule1 and return nested calls result
    // Reuse lambda_sum_product to get sum and product of a,b; add them and then call add_then_return_fixed
    public fun nested_calls(a: u8, b: u8): u8 {
        let (sum, product) = TestModule1::lambda_sum_product(a, b);
        let combined = sum + product;
        let fixed = TestModule1::add_then_return_fixed(combined, 0u8);
        fixed
    }
}




//# publish
module 0xCAFE::TestSpec {
    /// Specification pattern for feature 5, mimicking named spec patterns with asterisks
    spec module {
        pattern name_with_stars {
            aborts_if false;  // dummy spec pattern with ident*ident* ident* without spaces replaced with valid syntax
        }
    }
}




//# publish
module 0xCAFE::AbilityCheck {
    // Feature 6: enforce ability constraints in function signatures

    // Only types with copy+store can be passed here (e.g. u8, u64)
    public fun require_copy_store<T: copy + store>(x: T): T {
        x
    }

    // Types must have drop ability
    public fun require_drop<T: drop>(x: T): T {
        x
    }

    // Combined ability constraints
    public fun require_all<T: copy + drop + store>(x: T): T {
        x
    }
}




//# run 0xCAFE::TestModule1::add_then_return_fixed --args 10u8 32u8




//# run 0xCAFE::TestModule1::lambda_sum_product --args 3u8 5u8




//# run 0xCAFE::TestModule1::test_foo --args 77u8




//# run 0xCAFE::TestModule2::nested_calls --args 2u8 3u8




//# run 0xCAFE::AbilityCheck::require_copy_store --args 42u8




//# run 0xCAFE::AbilityCheck::require_drop --type-args u8 --args 15u8




//# run 0xCAFE::AbilityCheck::require_all --type-args u8 --args 99u8
