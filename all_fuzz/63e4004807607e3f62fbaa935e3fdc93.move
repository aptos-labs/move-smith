
//# publish
module 0xCAFE::MyModule {
    // Since CallerModule wants to call MyModule::f2, define f2 here.
    // Assume f2 is an inline function that takes u16 and returns (u16, u16)
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

//# publish
module 0xCAFE::AddModule {
    // Test 1: Function that adds two u8 values and returns a fixed u8 result
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b;
        let _fixed_return = 42u8;
        _fixed_return
    }

    // Test 2: Function containing lambdas that add and multiply numbers
    public fun lambdas_test(x: u8, y: u8): (u8, u8) {
        let add_lambda: |u8, u8| u8 = |a: u8, b: u8| {
            a + b
        };
        let mul_lambda: |u8, u8| u8 = |a: u8, b: u8| {
            a * b
        };
        let add_result = add_lambda(x, y);
        let mul_result = mul_lambda(x, y);
        (add_result, mul_result)
    }
}



//# run 0xCAFE::AddModule::add_and_return_fixed --args 40u8 2u8


//# run 0xCAFE::AddModule::lambdas_test --args 6u8 7u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;
    use 0xCAFE::MyModule;

    // Test 3: Call inline function f2 in MyModule from another module through nested function calls
    // Note: To call the inline function f2, we create a wrapper function in MyModule that calls it.
    public fun wrapper_for_f2(a: u16): (u16, u16) {
        MyModule::f2(a)
    }

    public fun nested_calls(a: u16): u16 {
        let (a1, a2) = wrapper_for_f2(a);
        let sum = a1 + a2 + (AddModule::add_and_return_fixed(1u8, 1u8) as u16);
        sum
    }
}


//# run 0xCAFE::CallerModule::nested_calls --args 10u16
