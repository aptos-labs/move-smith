//# publish
module 0x1::ModuleA {
    // Function that returns a simple u64 value
    public fun get_value(): u64 {
        42
    }
    
    // Function that takes a u64 argument
    public fun set_value(val: u64) {
        // does nothing
    }
    
    // Function that demonstrates schema declaration
    struct MySchema<SchemaName: vector<u8>> has copy, drop, store {
        field_1: u64,
        field_2: bool,
    }

    // Function to create an instance of schema
    public fun create_schema_instance<SchemaName: vector<u8>>(val: u64, flag: bool): MySchema<SchemaName> {
        MySchema<SchemaName> {
            field_1: val,
            field_2: flag,
        }
    }
}

//# publish
module 0x2::ModuleB {
    // Function that returns a u8
    public fun get_u8_value(): u8 {
        255
    }

    // Function that takes a value of a different address domain
    public fun call_modulea_get_value(addr: address): u64 {
        // Call get_value from ModuleA at address 'addr'
        move_to(addr, 0x1::ModuleA::get_value)
    }
}
 
//# publish
module 0x3::SchemaModule {
    struct UserSchema<SchemaName: vector<u8>> has copy, drop, store {
        id: u64,
        name: vector<u8>,
    }

    public fun create_user_schema<SchemaName: vector<u8>>(id: u64, name: vector<u8>): UserSchema<SchemaName> {
        UserSchema<SchemaName> {
            id,
            name,
        }
    }
}

//# run
script {
    use 0x1::ModuleA;
    /// Call get_value from ModuleA
    let val = ModuleA::get_value();
    // For testing cross address call, attempt to invoke a module from another address (simulate failure)
    // (Note: Actual cross-module address call is limited; here we simulate by directly calling)
}

//# run 0x2::ModuleB::call_modulea_get_value --signers 0xBEEF --args (0x1)

//# run
script {
    use 0x3::SchemaModule;
    /// Create a schema instance with a string (vector<u8>)
    let schema_instance = SchemaModule::create_user_schema<b"TestSchema">(
        123,
        b"UserName"
    );
}

// Additional test: addressing cross module calls with address literal, type union, and schema declaration

//# run
script {
    use 0x2::ModuleB;
    // Attempt to call get_u8_value
    let val_u8 = ModuleB::get_u8_value();
    // Attempt cross-module call with address literal (simulate)
    // Note: Move does not allow direct address literals in scripts, so use address from args if needed
}

// Example of invoking a function with type union syntax, simulate inside a module

//# publish
module 0x4::TypeUnionTest {
    // Function to test type union syntax using '|'
    public fun test_union_types<type1: u8, type2: u64>(): (type1 | type2) {
        // For illustration, return a u64 cast to the union
        100u64
    }

    // Function to test double union syntax with '||'
    public fun test_double_union<type1: u8, type2: u64, type3: bool>(): (type1 | type2 || type3) {
        // Return 1u8 as example
        1u8
    }
}

//# run 0x4::TypeUnionTest::test_union_types --args
//# run 0x4::TypeUnionTest::test_double_union --args