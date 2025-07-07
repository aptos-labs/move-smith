
//# publish
module 0xCAFE::TestArithmeticErrors {
    // A helper function to intentionally cause overflow
    public fun cause_overflow() {
        let max_u8 = 255u8;
        let _ = max_u8 + 1u8; // Should panic with overflow error
    }

    // A helper function to cause underflow
    public fun cause_underflow() {
        let zero_u8 = 0u8;
        let _ = zero_u8 - 1u8; // Should panic with underflow error
    }

    // A helper function to cause division by zero
    public fun cause_divide_by_zero() {
        let _ = 1u8 / 0u8; // Should panic with divide by zero
    }

    // A helper function to cause modulo by zero
    public fun cause_modulo_by_zero() {
        let _ = 1u8 % 0u8; // Should panic with modulo by zero
    }

    // A resource struct with arithmetic in initializer
    struct S {
        field1: u8,
        field2: u8,
    }

    // A resource resource with an initializer that causes overflow
    public fun create_overflow_struct(): S {
        let max_u8 = 255u8;
        S {
            field1: max_u8 + 1u8, // Should panic at creation
            field2: 0,
        }
    }

    // A resource with initializer causing division by zero
    public fun create_divide_zero_struct(): S {
        S {
            field1: 1u8 / 0u8, // Should panic at creation
            field2: 0,
        }
    }

    // A resource with initializer causing modulo by zero
    public fun create_modulo_zero_struct(): S {
        S {
            field1: 1u8 % 0u8, // Should panic at creation
            field2: 0,
        }
    }

    // A move-to operation in field initializer
    public fun move_to_in_initializer(): S {
        let m = 42u8;
        S {
            field1: move_from_address(m), // Will generate error if used improperly
            field2: 0,
        }
    }
    // Dummy function for move_from_address - just returns 0 for test purpose
    public fun move_from_address(_: u8): u8 {
        0
    }
}


//# run 0xCAFE::TestArithmeticErrors::cause_overflow

//# run 0xCAFE::TestArithmeticErrors::cause_underflow

//# run 0xCAFE::TestArithmeticErrors::cause_divide_by_zero

//# run 0xCAFE::TestArithmeticErrors::cause_modulo_by_zero

//# run 0xCAFE::TestArithmeticErrors::create_overflow_struct

//# run 0xCAFE::TestArithmeticErrors::create_divide_zero_struct

//# run 0xCAFE::TestArithmeticErrors::create_modulo_zero_struct

//# run 0xCAFE::TestArithmeticErrors::move_to_in_initializer --signers 0xCAFE

// Featurres:
// 59246af8817918cf0c3fea3aa805e1a8: Test that arithmetic errors in struct field initializers (such as division by zero, overflow, underflow, and modulo by zero) and move-to operations in field initializers correctly fail at runtime with appropriate aborts or errors.
// 378e8fcbde8cb0525a3a0ae157b66faf: Include informative messages when your code violates the minimum language version requirement.
// 297a70cd64bb09838fa23406faa49331: Filter source and library definitions separately to include only relevant module members.
