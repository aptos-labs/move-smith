
//# publish
module 0xCAFE::LambdaModule {
    // Test lambda (anonymous function) expressions and usage
    public fun apply_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun nested_lambda(): u8 {
        let add = |x: u8, y: u8| { x + y };
        let multiply = |x: u8, y: u8| { x * y };
        let sum = add(2u8, 3u8);
        let product = multiply(4u8, 5u8);
        sum + product // 5 + 20 = 25
    }
}



//# run 0xCAFE::LambdaModule::apply_lambda --args 7u8 8u8



//# run 0xCAFE::LambdaModule::nested_lambda




//# publish
module 0xCAFE::MyModule {
    // Provide the f2 function inline to be called from another module.
    public inline fun f2(value: u16): (u16, u16) {
        // Just return value and value + 1 for example
        (value, value + 1)
    }
}



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::MyModule;

    // Call the inline function (f2) from MyModule inside a public function
    public fun call_inline_f2(value: u16): u16 {
        let (x, y) = MyModule::f2(value);
        x + y
    }
}



//# run 0xCAFE::NestedCallModule::call_inline_f2 --args 100u16




//# publish
module 0xCAFE::DeprecatedModule {
    // This module simulates a deprecated module usage.
    // We purposely do not use this but note a comment here saying it is deprecated.
    // Compiler warning expected when referencing deprecated modules (simulation comment only).
    public fun deprecated_function(): u8 {
        42u8
    }
}


///// Test for swapping two u64 values ////



//# publish
module 0xCAFE::SwapModule {
    public fun test(a: u64, b: u64): (u64, u64) {
        // Swap the values
        (b, a)
    }

    public fun main() {
        let a = 100u64;
        let b = 200u64;
        let (x, y) = test(a, b);
        assert!(x == 200u64, 1001);
        assert!(y == 100u64, 1002);
    }
}



//# run 0xCAFE::SwapModule::test --args 500u64 1000u64



//# run 0xCAFE::SwapModule::main
