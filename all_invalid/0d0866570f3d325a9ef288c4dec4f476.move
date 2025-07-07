
//# publish
module 0xCAFE::AttributeAndInvariantTest {
    use std::signer;

    // Attribute with address as argument for the module
    // address(0xCAFE)]
    struct AddrAttrStruct has store {
        val: u8,
    }

    // address(0xBEEF)]
    public fun use_attribute() : u8 {
        let s = AddrAttrStruct { val: 42 };
        s.val
    }

    // Function with loop having loop invariant
    public fun loop_with_invariant(mut x: u8): u8 {
        let i = 0u8;
        while (x < 10) invariant i <= 10 {
            x = x + 1;
            i = i + 1;
        };
        x
    }

    // Global variable declaration with optional initialization
    native global_var: u64;

    // Local variable declarations with and without initialization
    public fun local_vars_example(): u64 {
        let a = 10u64;
        let b: u64;
        b = 20u64;
        a + b
    }
}


//# run 0xCAFE::AttributeAndInvariantTest::use_attribute


//# run 0xCAFE::AttributeAndInvariantTest::loop_with_invariant --args 0u8


//# run 0xCAFE::AttributeAndInvariantTest::local_vars_example


// Featurres:
// 0f524c3f14f785cd03e63823e8ce03a8: Annotate code with attributes that can contain address values as arguments.
// b0d4d1c4495da5e90b52709d9f755bb8: Insert loop invariant conditions into the 'while' loop for verification purposes.
// d0cd78814514a0cf6437adc60d8328c0: Declare global or local variables with optional initialization
