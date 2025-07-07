
//# publish
module 0xCAFE::LambdaTest {
    public fun add_plus_one(x: u8, y: u8): u8 {
        let sum = x + y;
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a + 1
        };
        lambda(sum)
    }

    public fun nested_calls(a: u8, b: u8): u8 {
        add_plus_one(a, b)
    }
}


//# run 0xCAFE::LambdaTest::add_plus_one --args 5u8 10u8


//# run 0xCAFE::LambdaTest::nested_calls --args 7u8 8u8


//# publish
module 0xCAFE::NestedInlineTest {
    use 0xCAFE::LambdaTest;

    fun inline_add(a: u8, b: u8): u8 {
        LambdaTest::add_plus_one(a, b)
    }

    public fun call_inline_nested(a: u8, b: u8): u8 {
        inline_add(a, b)
    }
}


//# run 0xCAFE::NestedInlineTest::call_inline_nested --args 2u8 3u8


spec module 0xCAFE::LambdaTest {
    fun add_plus_one_spec(x: u8, y: u8) {
        // no state, just example spec function stub
    }
}

spec module 0xCAFE::NestedInlineTest {
    fun call_inline_nested_spec(x: u8, y: u8) {
        // no state, just example spec function stub
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 29d720a77ea1b7be7be985c39565fd2f: Include top-level spec blocks that can be functions or other spec definitions.
