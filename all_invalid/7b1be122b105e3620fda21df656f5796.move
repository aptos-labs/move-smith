
//# publish
module 0xBADD::FeatureTestModule {
    // This module exercises resolving attribute values, constants, and function expressions.

    const CONST_U8: u8 = 255;
    const CONST_U16: u16 = 65535;
    const CONST_U32: u32 = 4294967295;
    const CONST_VEC_U8: vector<u8> = b"TestVector";

    // Function to return the constant values
    public fun get_constants(): (u8, u16, u32, vector<u8>) {
        (CONST_U8, CONST_U16, CONST_U32, CONST_VEC_U8)
    }

    // Function to invoke a function expression directly
    public fun exp_call(x: u8): u8 {
        // Simple lambda that adds 10
        let lambda: |u8| -> u8 = |a| a + 10;
        lambda(x)
    }

    // Runner function to sum constants and invoke exp_call
    public fun run_all(): (u8, u16, u32, vector<u8>, u8) {
        let (c_u8, c_u16, c_u32, c_vec) = get_constants();
        let result = exp_call(c_u8);
        (c_u8, c_u16, c_u32, c_vec, result)
    }
}


//# run 0xBADD::FeatureTestModule::run_all


// Featurres:
// 0ce29325acae4695fb0eb0243a619d9b: Resolve attribute value modules to their identifiers, including named addresses and module names.
// 6e816c93475426773118e5918e3a3c04: Test that constant declarations of primitive types and vectors are correctly supported and accessible in Move scripts.
// 59eeaca5bcf4cc5f8376169dc84b3bd8: Invoke function expressions directly with the `exp_call` expression.
