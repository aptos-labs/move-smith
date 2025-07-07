
//# publish
module 0xCAFE::UniqueIdentifierTest {
    use std::vector; // Warning: unused import, but keeping in case needed later

    // Module with a unique identifier for testing duplicate name prevention
    const MODULE_ID: u32 = 0xDEAD;

    struct UidStruct has store, key {
        id: u32,
    }

    public fun create_uid_struct(id: u32): UidStruct {
        UidStruct { id }
    }

    // Function with sequence expression in binary operations, involving variable modifications
    public fun sequence_expr_test(x: u64, y: u64): u64 {
        let a = x;
        let b = y;

        // Sequence expression with disallowed modification and use patterns
        // Move the sequence into a variable to avoid control flow misusage
        let result = {
            let a_new = a + 1;
            let b_new = b + 2;
            a_new + b_new
        };

        // Returning the computed result
        result
    }

    // Structs with private fields, and public functions accessing them selectively
    struct PrivateFieldStruct has store, key {
        secret: u8,
        public_value: u8,
    }

    // Only allow initialization of the struct
    public fun init_private_struct(secret_value: u8, public_value: u8): PrivateFieldStruct {
        PrivateFieldStruct { secret: secret_value, public_value }
    }

    // Function to get only the public part of the struct
    public fun get_public_value(s: &PrivateFieldStruct): u8 {
        s.public_value
    }

    // Function to modify only the public_value
    public fun update_public_value(s: &mut PrivateFieldStruct, new_value: u8) {
        s.public_value = new_value;
    }
}



//# run 0xCAFE::UniqueIdentifierTest::sequence_expr_test --args 10u64 20u64


//# run 0xCAFE::UniqueIdentifierTest::init_private_struct --args 42u8 100u8


//# run 0xCAFE::UniqueIdentifierTest::get_public_value --args --signers 0xBEEF


//# run 0xCAFE::UniqueIdentifierTest::update_public_value --args 50u8 --signers 0xBEEF