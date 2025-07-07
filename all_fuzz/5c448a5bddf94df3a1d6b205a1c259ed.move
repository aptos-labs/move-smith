
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        assert!(sum >= a, 100); // simple overflow check
        42u8
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(a, b);
        result
    }
}


//# run 0xCAFE::AdditionModule::add_two_values --args 10u8 15u8


//# run 0xCAFE::AdditionModule::add_with_lambda --args 20u8 22u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_add_twice(a: u8, b: u8): u8 {
        let first = AdditionModule::add_with_lambda(a, b);
        let second = AdditionModule::add_with_lambda(first, 1u8);
        second
    }

    public fun runner(): u8 {
        inline_add_twice(5u8, 10u8)
    }
}


//# run 0xCAFE::NestedCallModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
