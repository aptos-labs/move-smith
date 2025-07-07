
//# publish
module 0xCAFE::LambdaModule {
    public fun add_and_return_const(_a: u8, _b: u8): u8 {
        // Removed unused binding warning by prefixing variables with underscore
        // Return the constant 42 regardless of sum
        42u8
    }

    public fun test_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a + 1u8
        };
        lambda(x)
    }

    public fun runner_lambda() {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let _res = lambda(5u8, 7u8);
    }
}



//# run 0xCAFE::LambdaModule::add_and_return_const --args 10u8 15u8



//# run 0xCAFE::LambdaModule::test_lambda --args 7u8



//# run 0xCAFE::LambdaModule::runner_lambda




//# publish
module 0xCAFE::NestedInlineModule {
    // Removed the use of 0xCAFE::MyModule per guidelines - define inline function instead of cross-module call

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    // Provide an equivalent internal implementation for f2 (returns a tuple of u16)
    public fun f2(a: u16): (u16, u16) {
        // Example implementation: return (a, a + 1)
        (a, a + 1)
    }

    public fun call_my_module_f2(a: u16): u16 {
        let (res1, res2) = Self::f2(a);
        res1 + res2
    }

    public fun nested_calls(x: u8, y: u8, z: u16): (u8, u16) {
        let sum = inline_add(x, y);
        let nested_sum = call_my_module_f2(z);
        (sum, nested_sum)
    }

    public fun runner() {
        let (s, t) = nested_calls(3u8, 4u8, 10u16);
        let _ = s;
        let _ = t;
    }
}



//# run 0xCAFE::NestedInlineModule::call_my_module_f2 --args 20u16



//# run 0xCAFE::NestedInlineModule::nested_calls --args 2u8 3u8 5u16



//# run 0xCAFE::NestedInlineModule::runner
