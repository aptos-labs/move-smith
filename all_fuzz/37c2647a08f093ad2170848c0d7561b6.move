
//# publish
module 0xCAFE::LambdaTest {

    // Function that adds two u8 values and returns result + 10
    public fun add_then_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function containing a lambda that multiplies by 3 then adds 5
    public fun lambda_expression(x: u8): u8 {
        let f: |u8| u8 has copy+drop = |v: u8| {
            (v * 3) + 5
        };
        f(x)
    }

    // Runner function that calls add_then_offset and lambda_expression
    public fun runner(): (u8, u8) {
        let res1 = add_then_offset(7u8, 8u8);   // 7+8=15, +10=25
        let res2 = lambda_expression(4u8);      // 4*3=12+5=17
        (res1, res2)
    }
}


//# publish
module 0xCAFE::InlineCallTest {

    // Import LambdaTest to call its inline function (simulate inline via public function)
    use 0xCAFE::LambdaTest;

    // Inline function returning a tuple with incremented u16 values
    public inline fun increment_tuple(a: u16): (u16, u16) {
        (a + 2, a + 3)
    }

    // Function that calls LambdaTest::runner and InlineCallTest::increment_tuple nested
    public fun nested_calls(a: u8, b: u8, c: u16): (u8, u8, u16, u16) {
        let (r1, r2) = LambdaTest::runner();
        let (inc1, inc2) = increment_tuple(c);
        (r1 + a, r2 + b, inc1, inc2)
    }
}


//# run 0xCAFE::LambdaTest::add_then_offset --args 5u8 7u8


//# run 0xCAFE::LambdaTest::lambda_expression --args 6u8


//# run 0xCAFE::LambdaTest::runner


//# run 0xCAFE::InlineCallTest::nested_calls --args 2u8 3u8 10u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
