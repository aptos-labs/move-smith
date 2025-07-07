//# publish
module 0xCAFE::FriendModuleA {
    friend 0xCAFE::FriendModuleB;

    struct Data has store, key {
        value: u64,
    }

    public fun create_data(value: u64): Data {
        Data { value }
    }

    public fun get_value(data: &Data): u64 {
        data.value
    }
}

//# publish
module 0xCAFE::FriendModuleB {
    friend 0xCAFE::FriendModuleA;

    use 0xCAFE::FriendModuleA;

    public fun read_data_from_a(data: &FriendModuleA::Data): u64 {
        // Access the field directly inside friend module
        data.value
    }

    public fun create_and_read(): u64 {
        let data = FriendModuleA::create_data(42);
        read_data_from_a(&data)
    }
}

// This module declaration tests multiple addresses for the same module name.
// This is a negative test case - actually Aptos does not allow it.
// To simulate it in this transaction test, we define the same module with different address names here:

//# publish
module 0xCAFE::DuplicateModuleName {
    public fun dummy1(): u8 {
        1u8
    }
}

//# publish
module 0xBEEF::DuplicateModuleName {
    public fun dummy2(): u8 {
        2u8
    }
}

//# run 0xCAFE::FriendModuleB::create_and_read

//# run 0xCAFE::FriendModuleA::get_value --args 123u64

//# run 0xCAFE::DuplicateModuleName::dummy1

//# run 0xBEEF::DuplicateModuleName::dummy2

// Featurres:
// 81df5e2bdf888923694038d544bd8b42: Declare friend modules with the 'friend' mechanism.
// fda188fe1ba52851ff503c9efdd2a9d9: Attach the generated compiled bytecode directly to the analysis model after successful compilation.
// b385732b63292b89376cb6b2a462e89c: Prevent multiple addresses from being specified for the same module in a module declaration.
