
//# publish
module 0xCAFE::LambdaTest {
    use std::vector;

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = add_lambda(x, y);
        result + 5u8
    }

    public fun nested_lambda(): u8 {
        let outer_lambda: |u8| u8 has copy+drop = |a: u8| {
            let inner_lambda: |u8| u8 has copy+drop = |b: u8| {
                b * 2u8
            };
            inner_lambda(a) + 1u8
        };
        outer_lambda(3u8)
    }

    public inline fun tuple_return(x: u8): (u8, u8) {
        (x + 1u8, x + 2u8)
    }

    public fun call_tuple_return(x: u8): u8 {
        let (a, b) = tuple_return(x);
        a + b
    }

    public fun return_with_value(): u8 {
        return 42u8
    }

    public fun return_without_value() {
        return;
    }

    public fun repeated_elements(x: u8): u8 {
        // tuple literal with repeated elements
        let t = (x, x, x);
        // calling function with repeated arguments
        let sum = add_three(x, x, x);
        // repeated type param list example
        let v1 = vector::empty<u8>();
        let v2 = vector::empty<u8>();
        sum + t.0 + t.1 + t.2 + (vector::is_empty(&v1) as u8) + (vector::is_empty(&v2) as u8)
    }

    fun add_three(a: u8, b: u8, c: u8): u8 {
        a + b + c
    }
}


//# run 0xCAFE::LambdaTest::add_two_u8 --args 10u8 20u8


//# run 0xCAFE::LambdaTest::lambda_example --args 2u8 3u8


//# run 0xCAFE::LambdaTest::nested_lambda


//# run 0xCAFE::LambdaTest::call_tuple_return --args 5u8


//# run 0xCAFE::LambdaTest::return_with_value


//# run 0xCAFE::LambdaTest::return_without_value


//# run 0xCAFE::LambdaTest::repeated_elements --args 2u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaTest;

    public fun call_add_two_u8(a: u8, b: u8): u8 {
        LambdaTest::add_two_u8(a, b)
    }

    public fun call_lambda_example(a: u8, b: u8): u8 {
        LambdaTest::lambda_example(a, b)
    }

    public fun call_call_tuple_return(x: u8): u8 {
        LambdaTest::call_tuple_return(x)
    }
}


//# run 0xCAFE::CallerModule::call_add_two_u8 --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_lambda_example --args 1u8 1u8


//# run 0xCAFE::CallerModule::call_call_tuple_return --args 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c2a87e653143cce1e6d6463e6d200f77: Return from functions using the `return` expression, optionally with a value.
// 1c880e7f3f6ec09ab6bdc8348893ec4b: Enable parsing of constructs in Move that may involve repeated elements, such as tuple literals, argument lists, or type parameter lists.
