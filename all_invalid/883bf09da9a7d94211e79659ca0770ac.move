//# publish
module 0xCAFE::TestModule {
    // Define a constant to test annotation with address
    const ADDR_CONST: address = 0xDEADBEEF;

    // Struct with various abilities
    struct TestStruct {
        value: u64,
        flag: bool
    }

    // Function to create and return a TestStruct
    public fun create_struct(value: u64, flag: bool): TestStruct {
        TestStruct { value, flag }
    }

    // Function to access the constant
    public fun get_addr_const(): address {
        Self::ADDR_CONST
    }

    // Function to demonstrate type casting
    public fun type_casting_demo(x: u64): u8 {
        (x as u8) // cast to u8, should be valid for small numbers
    }

    // Function to demonstrate tuple unpacking
    public fun tuple_unpack_demo(): (u64, bool) {
        let (a, b) = (42u64, true);
        (a, b)
    }

    // Function to test annotations on functions
    #[test]
    public fun annotated_function_demo(): u64 {
        12345
    }
}

//# run 0xCAFE::TestModule::create_struct --signers 0xCAFE --args 100u64 false
//# run 0xCAFE::TestModule::get_addr_const --signers 0xCAFE
//# run 0xCAFE::TestModule::type_casting_demo --signers 0xCAFE --args 255u64
//# run 0xCAFE::TestModule::tuple_unpack_demo --signers 0xCAFE
//# run 0xCAFE::TestModule::annotated_function_demo --signers 0xCAFE

// Features:
// 0f524c3f14f785cd03e63823e8ce03a8: Annotate code with attributes that can contain address values as arguments.
// 412c37a369174b3d23ed9d4bdb8b1208: Define module members with specific kinds such as functions, structs, or constants.
// d5ae5ffa6b3cb49ad37b0b0edab9aa3c: Render sorted and unique diagnostics for display to assist developers in identifying issues.