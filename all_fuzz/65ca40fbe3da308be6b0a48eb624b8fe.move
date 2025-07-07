
//# publish
module 0xCAFE::Adder {
    // Simple adder module to test addition of two u8 values
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus 10 as a final value, to test computation and return
        sum + 10
    }
}


//# run 0xCAFE::Adder::add_two_values --args 5u8 7u8


//# publish
module 0xCAFE::LambdaTest {
    // Module to test lambda (anonymous function) expressions
    
    public fun lambda_no_capture(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        f(x)
    }

    public fun lambda_with_capture(x: u8, y: u8): u8 {
        let base = x;
        let f: |u8|u8 has copy+drop = |a: u8| { base + a + y };
        f(x)
    }

    public fun call_lambda_twice(x: u8): (u8, u8) {
        let f: |u8|u8 has copy+drop = |a: u8| { a + 2 };
        let res1 = f(x);
        let res2 = f(res1);
        (res1, res2)
    }
}


//# run 0xCAFE::LambdaTest::lambda_no_capture --args 9u8


//# run 0xCAFE::LambdaTest::lambda_with_capture --args 3u8 4u8


//# run 0xCAFE::LambdaTest::call_lambda_twice --args 1u8


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::Adder;
    
    // Function that calls an inline function from a submodule inside Adder
    // Actually, reusing Adder's add_two_values function which returns sum + 10
    
    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun nested_call(a: u8, b:u8): u8 {
        let partial = Adder::add_two_values(a, b);
        let result = inline_increment(partial);
        result
    }
}


//# run 0xCAFE::NestedCallTest::nested_call --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
