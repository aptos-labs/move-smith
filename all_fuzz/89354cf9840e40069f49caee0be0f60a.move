
//# publish
module 0xCAFE::LambdaAndInlineTest {
    use std::vector;

    // A public inline function that returns triple of an u16
    public inline fun triple(a: u16): u16 {
        a * 3
    }

    // Public function with lambda/closure
    public fun apply_lambda(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b + 1
        };
        f(x, y)
    }

    // Public function that calls the inline triple function twice and sums the results
    public fun call_inline_twice(a: u16): u16 {
        let t1 = triple(a);
        let t2 = triple(a + 1);
        t1 + t2
    }

    // Function without any logic, to test filtering of spec blocks
    fun internal_helper(x: u8): u8 {
        x + 10
    }
}


//# run 0xCAFE::LambdaAndInlineTest::apply_lambda --args 4u8 5u8


//# run 0xCAFE::LambdaAndInlineTest::call_inline_twice --args 7u16



//# publish
module 0xCAFE::InlineFunctionCaller {
    use 0xCAFE::LambdaAndInlineTest;

    // Calls inline function triple from another module zero times (just for coverage)
    public fun call_inline_zero() {
        let _ = LambdaAndInlineTest::triple(0);
    }

    // Calls inline function triple from LambdaAndInlineTest with 20u16
    public fun call_inline_20(): u16 {
        LambdaAndInlineTest::triple(20)
    }

    // Calls caller function that calls inline twice
    public fun call_call_inline_twice(a: u16): u16 {
        LambdaAndInlineTest::call_inline_twice(a)
    }
}


//# run 0xCAFE::InlineFunctionCaller::call_inline_zero


//# run 0xCAFE::InlineFunctionCaller::call_inline_20


//# run 0xCAFE::InlineFunctionCaller::call_call_inline_twice --args 9u16


// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d2dee3b6c3fd10b775b2a0089f2736ab: Utilize the filtering mechanism to remove specification (spec) blocks associated with module members that have been filtered out of the module.
