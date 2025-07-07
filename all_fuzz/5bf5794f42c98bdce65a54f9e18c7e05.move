
//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let fixed_result = 42u8;
        fixed_result
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }
}


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::AdditionTest;

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun call_inline_twice(a: u8): u8 {
        let first = inline_increment(a);
        let second = inline_increment(first);
        second
    }

    public fun call_external_inline(a: u8, b: u8): u8 {
        let sum = AdditionTest::lambda_add(a, b);
        inline_increment(sum)
    }
}


//# run 0xCAFE::AdditionTest::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::AdditionTest::lambda_add --args 5u8 15u8


//# run 0xCAFE::NestedCallTest::call_inline_twice --args 10u8


//# run 0xCAFE::NestedCallTest::call_external_inline --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
