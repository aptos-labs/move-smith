
//# publish
module 0xCAFE::LambdaModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let c = a + b;
        let result = if (c < 10) { c + 1 } else { 10 };
        result
    }

    public fun apply_lambda(x: u8): u8 {
        let f: |u8|u8 has copy + drop = |a: u8| {
            a * 2
        };
        f(x)
    }

    public fun nested_lambda(x: u8, y: u8): u8 {
        let f_outer: |u8, u8|u8 has copy + drop = |a: u8, b: u8| {
            let inner: |u8|u8 has copy + drop = |v: u8| {
                a + b + v
            };
            inner(1)
        };
        f_outer(x, y)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::LambdaModule;

    public fun call_inline_add(x: u8, y: u8): u8 {
        let sum = x + y;
        let incremented = LambdaModule::inline_increment(sum);
        incremented
    }

    public fun call_lambda_functions(x: u8): (u8, u8) {
        let doubled = LambdaModule::apply_lambda(x);
        let nested_result = LambdaModule::nested_lambda(x, 3u8);
        (doubled, nested_result)
    }
}


//# run 0xCAFE::LambdaModule::add_two_values --args 4u8 3u8


//# run 0xCAFE::LambdaModule::apply_lambda --args 5u8


//# run 0xCAFE::LambdaModule::nested_lambda --args 2u8 4u8


//# run 0xCAFE::NestedCallModule::call_inline_add --args 7u8 2u8


//# run 0xCAFE::NestedCallModule::call_lambda_functions --args 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
