
//# publish
module 0xCAFE::TestModule {
    use std::vector;
    use std::signer;

    // Function to test mutably borrowing a parameter and modifying it internally
    public fun test_mut_borrow_and_return(x: u64): u64 acquires {} {
        let val = x;
        // borrow mutably
        let val_ref: &mut u64 = &mut val;
        *val_ref = *val_ref + 10;
        // Return original x
        x
    }

    // Function to create a packed value with module access, type args, and fields
    public fun create_pack_value<T>(field_value: T): (vector<u8>, T) {
        // Pack a vector with module address and the field value
        let module_address_bytes = b"0xCAFEnonnice";
        let packed_data = vector::concat(module_address_bytes, b"::Field");
        (packed_data, field_value)
    }

    // Function that constructs a value with explicit module access and type parameter
    public fun construct_struct_with_typeparameter<T>(val: T): (u8, T) {
        (42, val)
    }

    // Function with module specification for a predicate to be true
    public fun specify_predicate(x: u8): bool {
        // Specification: ensure x is less than 255
        x < 255
    }

    // Function to test definitions with specs
    public fun test_specs(x: u8): bool {
        specify_predicate(x)
    }

    /// Runner function to call test_mut_borrow_and_return with predefined value
    public fun run_test_borrow() {
        let result = test_mut_borrow_and_return(55);
        // result should be 55, the original value
        assert!(result == 55, 999);
    }

    /// Runner function to call create_pack_value with an example value
    public fun run_create_pack_value() {
        let (packed, val) = create_pack_value::<u32>(100u32);
        // Use the pack data in some way or assert length
        assert!(vector::length(&packed) > 0, 1000);
    }

    /// Runner for constructing struct with type parameter
    public fun run_construct_struct() {
        let (num, val) = construct_struct_with_typeparameter::<u8>(77);
        assert!(num == 42, 1001);
        assert!(val == 77, 1002);
    }

    /// Runner to test specifications
    public fun run_spec_tests() {
        assert!(test_specs(100), 1003);
        assert!(!test_specs(255), 1004);
    }
}


//# run 0xCAFE::TestModule::run_test_borrow --signers 0xBADD --args 55u64


//# run 0xCAFE::TestModule::run_create_pack_value --signers 0xBADD


//# run 0xCAFE::TestModule::run_construct_struct --signers 0xBADD


//# run 0xCAFE::TestModule::run_spec_tests --signers 0xBADD

// Featurres:
// ff16a95e0f30a19975f0caf60cfe06bd: Test that mutably borrowing a parameter and modifying it within a function does not affect the function’s return value when the original value is used in an assertion.
// cfc2fdac37678eab319a0d31c41e206f: Construct pack values with module access, type arguments, and fields.
// befbd44b25f972db977a1c9b71c39e28: Declare specifications (specs) within modules.
