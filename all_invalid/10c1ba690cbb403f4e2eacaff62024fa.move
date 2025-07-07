
//# publish
module 0xCAFE::FeatureTestModule {
    use std::vector;
    use std::signer;

    // Defines a simple module with functions to test call expressions
    public fun simple_add(a: u64, b: u64): u64 {
        a + b
    }

    public fun call_in_scheme(a: u64, b: u64): u64 {
        // Call the simple_add function using call expression
        call simple_add(a, b);
    }
}



//# run 0xCAFE::FeatureTestModule::simple_add --args 10u64 20u64



//# run 0xCAFE::FeatureTestModule::call_in_scheme --args 15u64 25u64




//# publish
module 0xCAFE::ConditionalAssignment {
    // Function that assigns a value based on a condition and returns it
    public fun assign_in_if_else(cond: bool, x: u32, y: u32): u32 {
        let result: u32;
        if (cond) {
            result = x;
        } else {
            result = y;
        };
        result
    }
}



//# run 0xCAFE::ConditionalAssignment::assign_in_if_else --args true 42u32 99u32



//# run 0xCAFE::ConditionalAssignment::assign_in_if_else --args false 42u32 99u32