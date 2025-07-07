
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun lambda_test(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| { a * 2u8 };
        lambda(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::AddModule;

    public fun nested_calls(x: u8, y: u8): u8 {
        let intermediate = AddModule::inline_add(x, y);
        AddModule::add_and_return_sum(intermediate, 10u8)
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 7u8 5u8


//# run 0xCAFE::AddModule::lambda_test --args 8u8


//# run 0xCAFE::NestedCallTest::nested_calls --args 4u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
