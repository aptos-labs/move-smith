
//# publish
module 0xCAFE::TestFeatures {
    // Removed unused use std::signer;
    // Removed use 0xCAFE::MyModule; because it does not exist

    // 1: Test addition of two u8 values and return a fixed value
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        let _fixed_value = 42u8;
        sum + _fixed_value
    }

    // 2: Function containing a lambda expression that doubles input and adds a captured variable
    public fun lambda_test(x: u8): u8 {
        let captured = 10u8;
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a * 2 + captured
        };
        lambda(x)
    }

    // 3: Since 0xCAFE::MyModule and its function f2 do not exist, we define a local inline function f2 here.
    // It returns a tuple (u16, u16) for demonstration.
    inline fun f2(x: u16): (u16, u16) {
        // For example, return (x, x * 2)
        (x, x * 2)
    }

    // 3: Call inline function f2 from this module, use its returned tuple's first element and add a constant
    public fun call_inline_function_and_add(x: u16): u16 {
        let (a, _b) = f2(x);
        a + 100u16
    }

    // 4: Reference function parameter, take multiple immutable references and dereference to return original value
    public fun ref_and_deref(x: u8): u8 {
        let ref1 = &x;
        let ref2 = &(*ref1);
        *ref2
    }

    // Runner function to test all above functions with some sample inputs
    public fun runner(): (u8, u8, u16, u8) {
        let res1 = add_and_return_fixed(10u8, 32u8);
        let res2 = lambda_test(5u8);
        let res3 = call_inline_function_and_add(200u16);
        let res4 = ref_and_deref(123u8);
        (res1, res2, res3, res4)
    }
}



//# run 0xCAFE::TestFeatures::add_and_return_fixed --args 5u8 10u8



//# run 0xCAFE::TestFeatures::lambda_test --args 7u8



//# run 0xCAFE::TestFeatures::call_inline_function_and_add --args 50u16



//# run 0xCAFE::TestFeatures::ref_and_deref --args 255u8



//# run 0xCAFE::TestFeatures::runner
