
//# publish
module 0xCAFE::FeatureTest {
    use std::signer;

    // 4. Struct with type parameter constrained to copy and drop abilities
    struct Wrapper<T: copy + drop> has copy, drop {
        field: T
    }

    // Simple struct as constrained type parameter
    struct Dummy has copy, drop {
        value: u8
    }

    // 1. Function adding two u8 values then returning 42 if sum is 10, else 0
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            42
        } else {
            0
        };
    }

    // 2. Function demonstrating use of lambda: increment a u8 by a captured amount
    public fun lambda_incrementer(base: u8): u8 {
        let increment: |u8| u8 has copy + drop = |x: u8| { x + base };
        increment(5u8)
    }

    // 3. Call inline function in this module from another module will be tested later,
    // but we provide the inline function here.
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    // 5, 6. Specification with condition expression and quantifier where clause
    spec module {
        invariant [AddInvariant] forall a: u8, b: u8 where a + b <= 100 {
            add_and_check(a, b) == 42 || add_and_check(a, b) == 0;
        }
    }
}


//# publish
module 0xCAFE::FeatureTestCaller {
    use 0xCAFE::FeatureTest;
    use std::signer;

    // Call the inline function from FeatureTest
    public fun call_inline_add(a: u8, b: u8): u8 {
        FeatureTest::inline_add(a, b)
    }

    // Call lambda_incrementer from FeatureTest via indirect call
    public fun call_lambda(base: u8): u8 {
        FeatureTest::lambda_incrementer(base)
    }

    // Use Wrapper struct with constrained type parameter and instantiate with Dummy
    public fun use_wrapper(val: u8): u8 {
        let dummy = FeatureTest::Dummy { value: val };
        let wrapped = FeatureTest::Wrapper<Dummy> { field: dummy };
        wrapped.field.value
    }
}


//# run 0xCAFE::FeatureTest::add_and_check --args 3u8 7u8


//# run 0xCAFE::FeatureTest::add_and_check --args 2u8 3u8


//# run 0xCAFE::FeatureTest::lambda_incrementer --args 10u8


//# run 0xCAFE::FeatureTestCaller::call_inline_add --args 12u8 30u8


//# run 0xCAFE::FeatureTestCaller::call_lambda --args 15u8


//# run 0xCAFE::FeatureTestCaller::use_wrapper --args 99u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// b6f59781a2434810c7c4757062670e46: Specify the constraints for struct type parameters using an ability set, such as copy or drop abilities.
// 7162635b65d891d4b5881a0396dd4f7a: Reference the condition expressions associated with invariants in specifications.
// d945dc417d77917518473d5006c670b6: Use 'where' clauses within quantifiers to specify conditions.
