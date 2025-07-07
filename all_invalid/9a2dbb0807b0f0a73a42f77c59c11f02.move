//# publish
module 0xABC::TestModule {
    use std::signer;

    // Define a struct with multiple fields of different integer types
    struct TestStruct has copy, drop, store {
        field_u8: u8,
        field_u64: u64,
        field_u128: u128,
        field_bool: bool,
    }

    // Function with parameters of different types and returning a u64
    public fun compute_sum(a: u8, b: u64, c: u128, flag: bool): u64 {
        let sum_u8 = a as u64;
        let sum_u64 = b + sum_u8;
        if (flag) {
            return sum_u64 + c as u64;
        } else {
            return sum_u64;
        }
    }

    // Function constructing and returning a TestStruct (with local vars and literals)
    public fun create_struct(): TestStruct {
        let val_u8: u8 = 42;
        let val_u64: u64 = 1000;
        let val_u128: u128 = 5000;
        let val_bool: bool = true;

        TestStruct {
            field_u8: val_u8,
            field_u64: val_u64,
            field_u128: val_u128,
            field_bool: val_bool,
        }
    }

    // Function using a friend (module or entity) access chain
    public fun get_related_struct(friend: &signer): TestStruct {
        // For demonstration, just call create_struct (simulate friend access)
        create_struct()
    }

    // Runner function to invoke create_struct
    public fun run_create_struct(): () {
        create_struct()
    }
}

//# run 0xABC::TestModule::compute_sum --signers 0x1 --args 10u8 20u64 30u128 false
//# run 0xABC::TestModule::compute_sum --signers 0x1 --args 255u8 50u64 123u128 true
//# run 0xABC::TestModule::get_related_struct --signers 0x1
//# run 0xABC::TestModule::run_create_struct --signers 0x1

// Featurres:
// 582ce7e20d31ee15d43990e650dc3397: Define functions with one or more parameters and a return type
// 431feb4d6c714a223a719930f11d883b: Specify the friend entity or module using a name access chain.
// 90826b291d5a9bbded1a82a5f81d9db9: Test that a function can correctly construct and return a struct with multiple fields of different integer types, initializing its fields with local variables and literals.
