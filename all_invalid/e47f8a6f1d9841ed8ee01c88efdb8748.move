//# publish
module 0xCAFE attribute_test_module {
    // Struct with attributes
    #[attribute1]
    struct AttrStruct {
        value: u64,
    }

    // Constant with attribute
    #[attribute2]
    const CONST_VALUE: u64 = 42;

    // Function with attribute
    #[attribute_fn]
    public fun get_const(): u64 {
        CONST_VALUE
    }

    // Function with multiple attributes
    #[attribute_fn, attribute1]
    public fun create_struct(val: u64): AttrStruct {
        AttrStruct { value: val }
    }
    
    // Internal helper function with attribute
    #[attribute_helper]
    fun helper_function(): bool {
        true
    }

    // Run a test to verify attributes are correctly associated by calling functions and creating structs
    public fun test_attributes(): bool {
        let s = create_struct(100);
        let val = get_const();
        // Use attribute; this function returns true if attribute functions work
        helper_function() && (s.value == 100) && (val == 42)
    }
}

//# run 0xCAFE::attribute_test_module::test_attributes --signers 0xCAFE

//# publish
module 0xCAFE evaluation_order_module {
    // Function to test block evaluation order
    public fun evaluate_blocks(): u64 {
        let result: u64 = 0;

        // First block evaluated
        result = {
            // Side effect: mutate local variable
            let temp = 10;
            // return value
            temp + 1
        };

        // Second block evaluated
        result = {
            // Side effect: mutate local variable
            let temp = result + 20;
            // return value
            temp * 2
        };

        // Third block
        result = {
            let temp = result + 5;
            temp
        };
        result
    }

    // Run the evaluation order test
    public fun test_evaluation_order(): u64 {
        evaluate_blocks()
    }
}

//# run 0xCAFE::evaluation_order_module::test_evaluation_order --signers 0xCAFE

// Featurres:
// dc97784057e0582c260f6ae7aae13485: Annotate module members (functions, constants, structs) with attributes
// 618ec165be600d3844d66fbef3466d89: Handle attributes with valid module identifiers or names, ensuring correct association of code locations with modules.
// 8ab2c2b88ea0c5733f361b383914e6f8: Test that blocks used as function arguments are evaluated in the correct left-to-right order, each block can mutate local variables, and the final result reflects these side effects.
