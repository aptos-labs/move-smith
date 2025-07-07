
//# publish
module 0xCAFE::AddModule {
    public fun add_then_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        // Returns a specific value, e.g., 42, ignoring sum result to show computing addition
        42
    }

    public fun use_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::AddModule::add_then_return_specific --args 5u8 8u8


//# run 0xCAFE::AddModule::use_lambda --args 3u8 4u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_inline_from_add_module(a: u8, b: u8): u8 {
        let (sum, _) = AddModule::use_lambda(a, b);
        let inc = inline_increment(sum);
        inc
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_from_add_module --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
