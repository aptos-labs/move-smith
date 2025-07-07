
//# publish
module 0xCAFE::TestFeatures {
    use std::vector;
    use 0xCAFE::MyModule;

    // A runner function to call within scripts
    public fun run_tests() {
        // This function can be called in scripts to test various features
        // For now, empty, placeholder
    }
}



//# run 0xCAFE::TestFeatures::run_tests



//# publish
module 0xCAFE::TestFeaturesBehaviour {
    use std::signer;
    use std::vector;
    use 0xCAFE::MyModule;

    // Test calling functions with explicit type arguments and argument lists
    public fun test_function_calls(s: signer) {
        // Call MyModule::f1 with explicit u8 type argument and values
        let _result_f1 = MyModule::f1::<u8>(5u8, true);

        // Call MyModule::f2 inline function with u16
        let a: u16 = 10u16;
        let (b1, b2) = MyModule::f2(a);
        // Create binding with variable names & post-state info
        let sum_b1_b2 = b1 + b2;

        // Call generic function with type parameter in a nested module
        let s_value = MyModule::f3::<u16>(15u16);

        // Call function with match expression and type casting
        let e = E::V2(3, 4);
        let match_x = match e {
            E::V1 => 0,
            E::V2(x, y) => (x + y) as u8,
            E::V3 { a } } => if (a) { 1 } else { 0 },
        };

        // Variable with inline variable binding and arithmetic operations
        let val1 = 42u8;
        let val2 = 58u8;
        let sum = val1 + val2;

        // Call f4, which asserts some condition
        MyModule::f4();

        // Call f5 with copying lambda
        MyModule::f5();

        // Call f6 with an inline lambda parameter
        let identity = |x: u8| -> u8 { x };
        let result = MyModule::f6::<u8>(identity, 7u8);

        // Use vector literals and raw bytes
        let string_bytes: vector<u8> = b"Test\nString";
        let hex_bytes: vector<u8> = x"abc123";

        // Some expression to involve type casts
        let casted_value = (100u16 as u32);
    }
}



//# run 0xCAFE::TestFeaturesBehaviour::test_function_calls --signers 0xBEEF