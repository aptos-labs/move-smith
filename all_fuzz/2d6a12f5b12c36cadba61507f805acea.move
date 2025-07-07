
//# publish
module 0xCAFE::AddModule {
    /// A simple struct to hold two values
    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    /// Adds two u8 values and checks the result then returns fixed value 42
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        // sum must be less than 100 (just a dummy assert)
        assert!(sum < 100, 123);
        // returns a fixed u8 value 42
        42
    }

    /// Function with a lambda (anonymous function) that adds two u8 values and returns the sum
    public fun apply_lambda(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        f(x, y)
    }

    /// Inline function that adds two u8
    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }

    /// Runner function that uses the inline_add multiple times and returns final sum
    public fun nested_calls(x: u8, y: u8): u8 {
        let a = inline_add(x, y);
        let b = inline_add(a, 1);
        b
    }

    /// A function that calls only non-move side-effect free functions multiple times
    public fun side_effect_free_test(x: u8, y: u8): u8 {
        // Call inline_add twice in a row — it’s side-effect free, returns value only
        let first = inline_add(x, y);
        let second = inline_add(first, y);
        second
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::AddModule::apply_lambda --args 5u8 7u8


//# run 0xCAFE::AddModule::nested_calls --args 3u8 4u8


//# run 0xCAFE::AddModule::side_effect_free_test --args 1u8 2u8


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::AddModule;

    /// Calls AddModule::nested_calls and then AddModule::apply_lambda
    public fun call_nested(x: u8, y: u8): u8 {
        let tmp = AddModule::nested_calls(x, y);
        let result = AddModule::apply_lambda(tmp, 1);
        result
    }
}


//# run 0xCAFE::NestedCaller::call_nested --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 26f6660ae3138fce9223bab9fdbd4006: Use function calls only with non-move functions to guarantee they are side-effect free.
// f3df3fa344ccbae8abb3badd913b4057: Annotate Move functions or modules with testing-specific attributes using #[test] or similar known testing attributes.
// 40b25a92ef0926381eceacf684bafd76: Declare abilities for a type by writing 'has' followed by the ability names after the type.
