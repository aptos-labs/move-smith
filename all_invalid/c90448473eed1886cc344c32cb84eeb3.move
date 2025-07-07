//# publish
module 0xCAFE::ModuleA {
    // Declare a struct using identifiers as field names
    struct MyStruct has store {
        // fields declared by using identifiers
        id: u64,
        name: vector<u8>,
    }

    // Function to assign attributes with a specific kind (using abilities here as attributes)
    #[test_only] // assigning an attribute for test only function
    public fun assign_attributes(): bool {
        true
    }

    // A runner function that calls assign_attributes, no arguments or signers needed
    public fun runner(): bool {
        assign_attributes()
    }
}
//# run 0xCAFE::ModuleA::runner

//# publish
module 0xCAFE::ModuleB {
    use std::string;
    use std::vector;

    // Access ModuleA's identifier by specifying its address and name explicitly
    // Create an instance of ModuleA::MyStruct and return the id field
    public fun access_module_identifier(): u64 {
        let my_struct = 0xCAFE::ModuleA::MyStruct {
            id: 42u64,
            name: string::utf8(b"Move Test")
        };
        my_struct.id
    }

    // Runner function: calls access_module_identifier
    public fun runner(): u64 {
        access_module_identifier()
    }
}
//# run 0xCAFE::ModuleB::runner

//# run
script {
    use 0xCAFE::ModuleA;
    use 0xCAFE::ModuleB;

    fun main() {
        let res_a = ModuleA::runner();
        let res_b = ModuleB::runner();
    }
}

// Featurres:
// a4ced2ee76fee4b1c8a50dfdf54ba003: Access a module's identifier by specifying its address and name.
// 298edeb4fd231be82b72e2d8929d3b7e: Declare struct fields using identifiers
// 5ec74372403f4f895ed472ad62123f67: Assign attributes with a specific kind in Move code.
