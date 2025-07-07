
//# publish
module 0xBADD::TestModules {
    use std::vector;

    struct DataStruct has store, key {
        value1: u64,
        value2: bool,
    }

    // Function to parse a value from tokens (simulate the parser behavior)
    public fun parse_value(token: u8): u8 {
        // In actual test, this could simulate parsing; here we just echo the token
        token
    }

    // Function to demonstrate use of positional fields in struct initialization
    public fun create_data_struct(): DataStruct {
        // Use positional initialization: omit field names
        let s = DataStruct { value1: 42u64, value2: true };
        s
    }

    // Function to test that parser returns expected value
    public fun test_parse_value(token: u8): u8 {
        parse_value(token)
    }

    // Function that constructs a module with named address
    public fun call_named_module_function(): u64 {
        0xCAFE::TestModules::parse_value(255)
    }

    // Runner function to invoke other functions
    public fun run_tests() {
        let val = create_data_struct();
        let parsed = test_parse_value(123u8);
        let named_addr_result = call_named_module_function();
    }
}



//# run 0xBADD::TestModules::run_tests