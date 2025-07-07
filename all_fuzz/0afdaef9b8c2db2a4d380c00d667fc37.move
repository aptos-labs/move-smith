
//# publish
module 0xCAFE::NestedLambdaTests {
    use std::vector;

    public fun add_and_return_42(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 0) {
            // dummy if to use sum
            let _ = sum;
        };
        42u8
    }

    public fun lambda_simple(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun inline_increment_by_one(a: u8): u8 {
        a + 1
    }
}


//# publish
module 0xCAFE::NestedLambdaCaller {
    use 0xCAFE::NestedLambdaTests;

    public fun call_inline_and_add_one(x: u8, y: u8): u8 {
        let intermediate = NestedLambdaTests::inline_increment_by_one(x);
        intermediate + y
    }

    public fun nested_closures(x: u8, y: u8): u8 {
        let outer_lambda: |u8| (|u8| u8) has copy+drop = |a: u8| {
            let inner_lambda: |u8| u8 has copy+drop = |b: u8| {
                a + b
            };
            inner_lambda
        };
        let inner = outer_lambda(x);
        inner(y)
    }

    public fun triple_nested_lambda(x: u8, y: u8, z: u8): u8 {
        // A triple nested closure using three levels of lambdas
        let level1: |u8| (|u8| (|u8| u8)) has copy+drop = |a: u8| {
            let level2 = |b: u8| {
                let level3 = |c: u8| {
                    a + b + c
                };
                level3
            };
            level2
        };
        let level2 = level1(x);
        let level3 = level2(y);
        level3(z)
    }
}


//# run 0xCAFE::NestedLambdaTests::add_and_return_42 --args 12u8 34u8


//# run 0xCAFE::NestedLambdaTests::lambda_simple --args 10u8 32u8


//# run 0xCAFE::NestedLambdaCaller::call_inline_and_add_one --args 40u8 2u8


//# run 0xCAFE::NestedLambdaCaller::nested_closures --args 5u8 7u8


//# run 0xCAFE::NestedLambdaCaller::triple_nested_lambda --args 3u8 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 81adbb1679cdd38eb72c44f7705f3e9c: Test that nested closures (lambdas) with various levels of nesting and captures are correctly type checked, invoked, and evaluated in the Aptos Move language.
