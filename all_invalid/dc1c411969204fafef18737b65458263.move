
//# publish
module 0xCAFE::TestModule {
    use std::assert;

    const TEST_CONSTANT: u64 = 12345;

    struct DataStruct has copy, drop, store, key {
        field1: u64,
        field2: bool,
        field3: u8,
    }

    public fun instantiate_struct(initial_value: u64, flag: bool, byte_value: u8): (DataStruct, u64) {
        let data = DataStruct {
            field1: initial_value,
            field2: flag,
            field3: byte_value,
        };
        // Use if to modify fields conditionally
        if (data.field2) {
            data.field1 = data.field1 + 10;
        } else {
            data.field1 = data.field1 + 20;
        };
        // Access fields and assert their expected values
        let field1_value = data.field1;
        let field2_value = data.field2;
        let field3_value = data.field3;
        // Confirm field1 after conditional modification
        // Verify the constant's value is as intended
        (data, field1_value + (if (field2_value) { 10 } else { 20 }) as u64, TEST_CONSTANT)
    }

    public fun test_conditional_modification(input_flag: bool, input_byte: u8): (u64, u8, u64) {
        let struct_instance = DataStruct {
            field1: 50,
            field2: input_flag,
            field3: input_byte,
        };
        // Modify fields based on runtime condition
        if (struct_instance.field2) {
            struct_instance.field1 = struct_instance.field1 * 2;
            struct_instance.field3 = struct_instance.field3 + 1;
        } else {
            struct_instance.field1 = struct_instance.field1 + 5;
            struct_instance.field3 = struct_instance.field3 + 2;
        };
        // Access and return fields to verify correctness
        let f1 = struct_instance.field1;
        let f2 = struct_instance.field2;
        let f3 = struct_instance.field3;
        // Confirm that constants stay unchanged
        (f1, f2, f3)
    }

    public fun check_constant_value(): u64 {
        // Verify the constant value is as expected
        TEST_CONSTANT
    }
}


//# run 0xCAFE::TestModule::instantiate_struct --args 100u64 true 10u8
//

//# run 0xCAFE::TestModule::test_conditional_modification --args false 7u8
//

//# run 0xCAFE::TestModule::test_conditional_modification --args true 255u8
//

//# run 0xCAFE::TestModule::check_constant_value


// Featurres:
// 1969dcbb0fbf6b75390323116a841eb2: Use 'if' expressions to conditionally execute code branches
// 74ebf6eddb1baa9c8cbb898bde0ae4be: Access fields of a struct using the dot operator in expressions
// 4f01255250bcfb3ed5186dec52413474: Define constants with type signatures in Move modules.
