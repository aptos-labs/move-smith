
//# publish
module 0xCAFE::MyModule {
    // Nested inline function f2 that takes a u16 and returns a tuple (u16, u16)
    public inline fun f2(x: u16): (u16, u16) {
        (x + 1, x + 2)
    }
}

//# publish
module 0xCAFE::FeatureTest {
    // Removed unused `use std::vector;` to fix warning

    // Function to compute addition of two u8 values and then add 10 to the result before returning
    public fun compute_add_then_add_10(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10;
        result
    }

    // Function containing a lambda expr that multiplies an input by 3 and then adds 7
    public fun lambda_test(x: u8): u8 {
        let multiply_add: |u8| u8 has copy+drop = |v: u8| {
            let product = v * 3;
            product + 7
        };
        multiply_add(x)
    }

    // Inline function adding 5 to input, to demonstrate nested inline calls across modules
    public inline fun inline_add_5(x: u8): u8 {
        x + 5
    }

    // Function that calls the inline function in this module and a nested inline function from MyModule::f2 
    public fun nested_inline_call(a: u16): (u8, u8) {
        // Call our inline_add_5 and convert u8 result to u16 for passing to MyModule::f2
        let local_result = inline_add_5(10u8) as u16;
        let (a1, a2) = 0xCAFE::MyModule::f2(local_result);
        // Convert (u16, u16) tuple output from f2 to (u8, u8) safely via casting/truncating
        ((a1 & 0xFF) as u8, (a2 & 0xFF) as u8)
    }

    // Function to test local variable kill and liveness semantics
    // It moves the same value through multiple locals and then modifies one; returning final untouched value
    public fun local_move_test() : u8 {
        let v1 = 42u8;
        let v2 = v1;
        let v3 = v2;
        // Reassign v2 to something else, v3 should still hold original
        let v2 = 100u8;
        v3
    }
}



//# run 0xCAFE::FeatureTest::compute_add_then_add_10 --args 12u8 8u8



//# run 0xCAFE::FeatureTest::lambda_test --args 5u8



//# run 0xCAFE::FeatureTest::nested_inline_call --args 30u16



//# run 0xCAFE::FeatureTest::local_move_test
