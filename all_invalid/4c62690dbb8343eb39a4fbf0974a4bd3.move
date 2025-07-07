
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

    // Correct the deprecated module placement by making it a nested module, but note
    // that modules should not be nested like this in Move. Usually, move modules are top-level.
    // To fix the error, remove the nested module and just keep its contents or declare it separately.
    // Since the module is empty, simply remove the nested 'DeprecatedModule' definition.

    // Function to convert a location attribute into a ModuleId
    public fun get_module_id_from_location(addr: address, module_name: vector<u8>): option::Option<move_module::ModuleId> {
        move_module::convert_location(addr, module_name)
    }
}



//# run 0xCAFE::TestModule::create_my_struct --signers 0xCAFE --args 42u64



//# run 0xCAFE::TestModule::create_generic_struct --signers 0xCAFE --args 100u64



//# run 0xCAFE::TestModule::get_module_id_from_location --signers 0xCAFE --args x"000000000000000000000000000000000000000000000000000000000000CAFE", b"TestModule"