
//# publish
module 0xCAFE::TestModule {
    use std::option;
    use std::vector;

    // A struct to test instantiation and storage
    struct MyStruct has copy, drop {
        value: u64,
    }

    // Generic struct with one type parameter
    struct GenericStruct<T> has copy, drop {
        inner: T,
    }

    // Function to create and return a MyStruct instance
    public fun create_my_struct(val: u64): MyStruct {
        MyStruct { value: val }
    }

    // Function to create and return a GenericStruct instance
    public fun create_generic_struct<T: copy + drop>(val: T): GenericStruct<T> {
        GenericStruct { inner: val }
    }

    // A deprecated module with annotation
    #[deprecated]
    module DeprecatedModule {
        // This is intentionally empty
    }

    // Function to convert a location attribute into a ModuleId
    public fun get_module_id_from_location(addr: address, module_name: vector<u8>): option::Option<move_module::ModuleId> {
        move_module::convert_location(addr, module_name)
    }
}


//# run 0xCAFE::TestModule::create_my_struct --signers 0xCAFE --args 42u64


//# run 0xCAFE::TestModule::create_generic_struct --signers 0xCAFE --args 100u64


//# run 0xCAFE::TestModule::get_module_id_from_location --signers 0xCAFE --args

// Featurres:
// e19b73ae6a5429540454b7a56c01d96b: Use the `convert_location` function to obtain a `ModuleId` from an attribute specifying a location, enabling linkage to specific modules.
// 1f09a30deb5ade0317891861ec701274: Identify deprecated modules in your code via annotations to be aware of their deprecated status.
// 71814ed2b9300233e88c1463ffcc3e9a: Define and instantiate custom structs, including parameterized (generic) structs.
