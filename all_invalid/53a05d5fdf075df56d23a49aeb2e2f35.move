
//# publish
module 0xABCD::NamedAddressModule {
    // This module is deployed at 0xABCD and will be referenced using a named address "Name"
    use std::vector;

    struct Item has copy, drop, store {
        id: u64,
        data: vector<u8>,
    }

    public fun create_item(id: u64): Item {
        let data = b"named_address_data";
        Item { id, data }
    }

    public fun id_plus(id: u64, plus: u64): u64 {
        id + plus
    }

    public fun anonymous_address_call(): u64 {
        // Dummy function to be called by anonymous address usage
        42
    }
}


//# publish
module 0x1234::AnonymousAddressModule {
    // Module at 0x1234 to test anonymous address usage
    use 0xABCD::NamedAddressModule;

    public fun call_named_address_fun(): u64 {
        // Calls a function in NamedAddressModule explicitly using full address
        NamedAddressModule::id_plus(100, 50)
    }

    public fun call_anon_address_fun(): u64 {
        // Return a constant from this module
        7
    }
}


//# publish
module 0xBEEF::WildcardAddressModule {
    // This module is published at 0xBEEF 
    // It tests use of wildcard * address in commands

    struct Data has copy, drop, store {
        value: u8,
    }

    public fun create_data(val: u8): Data {
        Data { value: val }
    }

    public fun add_values(a: u8, b: u8): u8 {
        a + b
    }

    public fun return_const(): u8 {
        99
    }
}


//# run *::AnonymousAddressModule::call_named_address_fun


//# run 0x1234::AnonymousAddressModule::call_named_address_fun


//# run 0xABCD::NamedAddressModule::id_plus --args 123u64 321u64


//# run Name::NamedAddressModule::id_plus --args 10u64 20u64


//# run 0xBEEF::WildcardAddressModule::add_values --args 5u8 10u8


//# run *::WildcardAddressModule::return_const


//# run 0xABCD::NamedAddressModule::anonymous_address_call


//# run *::AnonymousAddressModule::call_anon_address_fun


// Featurres:
// 9999df3dd137daa985289c06925f7542: Specify an address using a wildcard '*' for any address.
// 970bd57ac2075254b96bb63962a186fc: Use unnamed or anonymous addresses in module access expressions.
// c5d6a5f9cde63291ecf21af67224ce85: Use address specifier 'Name' to refer to a named address in your code.
