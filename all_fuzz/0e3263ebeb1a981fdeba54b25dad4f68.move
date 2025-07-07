
//# publish
module 0xCAFE::InnerModule {
    // Inline function that adds two u8 and returns u8
    public inline fun add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::OuterModule {
    use 0xCAFE::InnerModule;

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = InnerModule::add(x, y);
        // add a fixed number 10u8 and return to test the addition correctness
        sum + 10u8
    }

    public fun lambda_test(x: u8): u8 {
        let lam: |u8| u8 has copy + drop = |a: u8| {
            a + 5u8
        };
        lam(x)
    }

    public fun nested_lambda_test(x: u8, y: u8): u8 {
        let lam: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            let inner: |u8| u8 has copy + drop = |c: u8| {
                a + b + c
            };
            inner(2u8)
        };
        lam(x, y)
    }
}


//# publish
module 0xCAFE::MutVarModule {
    public fun foo(): u8 {
        let x = 0u8;
        x = 42u8;
        x
    }

    public fun test() {
        let result = foo();
        assert!(result == 42u8, 777);
    }
}


//# run 0xCAFE::OuterModule::add_two_values --args 5u8 15u8


//# run 0xCAFE::OuterModule::lambda_test --args 10u8


//# run 0xCAFE::OuterModule::nested_lambda_test --args 3u8 4u8


//# run 0xCAFE::MutVarModule::test


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// f7287dfab43402d782421e72dd15fe9a: Test that the function `foo` correctly assigns a new value to a mutable local variable and that the `test` function assert correctly verifies the result.
