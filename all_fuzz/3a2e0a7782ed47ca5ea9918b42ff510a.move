
//# publish
module 0xCAFE::DeprecationTest {
    use std::vector;

    // deprecated]
    // custom(attribute1)]
    struct DeprecatedStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    // deprecated]
    // custom(attribute_module)]
    public fun deprecated_fun(x: u8, y: u8): u8 {
        x + y
    }

    // deprecated]
    // custom(attribute_module)]
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::LambdaTest {
    // custom(lambda_attribute)]
    public fun run_lambdas(): u8 {
        let f_add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let f_mul: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let sum = f_add(5u8, 7u8);
        let product = f_mul(3u8, 4u8);
        sum + product
    }
}


//# publish
module 0xCAFE::CrossModuleCall {
    use 0xCAFE::DeprecationTest;

    public fun call_inline_add(x: u8, y: u8): u8 {
        let result = DeprecationTest::inline_add(x, y);
        result + 1u8
    }
}


//# publish
module 0xCAFE::LocalUpdateTest {
    // custom(local_update)]
    public fun local_var_update(x: u8): u8 {
        let mut_acc = {
            let temp = x;
            temp = temp + 1;
            temp = {
                temp + 1
            };
            temp
        };
        let final_value = mut_acc + 1;
        final_value
    }
}


//# run 0xCAFE::DeprecationTest::deprecated_fun --args 7u8 8u8


//# run 0xCAFE::LambdaTest::run_lambdas


//# run 0xCAFE::CrossModuleCall::call_inline_add --args 10u8 5u8


//# run 0xCAFE::LocalUpdateTest::local_var_update --args 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// dffa67cb5913057d2fb5542cb75c7d68: Annotate modules with deprecation status to indicate they are deprecated.
// d35278f6ffc00f9e950fdc8dad5ab55f: Annotate Move language items (such as functions, structs, or modules) with custom attributes.
// a2acc1502b08da208d2d08e4984609c4: Test that local variable updates within expression blocks are correctly evaluated and used in subsequent expressions, ensuring proper handling of state changes in nested blocks.
