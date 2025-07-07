
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Returns the sum plus 10 to differentiate result
        sum + 10
    }
}


//# run 0xCAFE::ComputeAdd::add_and_return --args 5u8 7u8


//# publish
module 0xCAFE::LambdaTest {
    public fun test_lambda(x: u8, y: u8): (u8, u8) {
        let add = |a: u8, b: u8| {
            a + b
        };
        let multiply = |a: u8, b: u8| {
            a * b
        };
        let sum = add(x, y);
        let product = multiply(x, y);
        (sum, product)
    }
}


//# run 0xCAFE::LambdaTest::test_lambda --args 4u8 3u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::ComputeAdd;

    public inline fun inline_double_add(a: u8, b: u8): u8 {
        let (temp1, temp2) = (ComputeAdd::add_and_return(a, b), ComputeAdd::add_and_return(b, a));
        // Returns the sum of both calls minus 10 to confirm inline and nested call
        temp1 + temp2 - 10
    }

    public fun runner(): u8 {
        inline_double_add(2u8, 3u8)
    }
}


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
