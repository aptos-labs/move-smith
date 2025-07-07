//# publish
module 0xCAFE::KeyAndFunctionsTest {
    use std::signer;

    /// A resource struct with the `key` ability to be used as a global resource.
    struct Data has key, store {
        id: u64,
        value: u8,
    }

    /// A struct without the key ability, just storing data.
    struct NoKeyData has store {
        data: u8,
    }

    /// A native function declaration with no body.
    native public fun native_no_body(a: u8): u8;

    /// An inline function with a body that adds two u8 integers.
    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }

    /// A public function creating a Data resource under signer's account.
    public fun create_data(s: signer, id: u64, val: u8) {
        let data = Data {id, value: val};
        move_to<Data>(&s, data);
    }

    /// A public function to read the value field from the Data resource.
    public fun read_value(s: signer): u8 {
        let address = signer::address_of(&s);
        let data_ref = borrow_global<Data>(address);
        data_ref.value
    }

    /// A public function that modifies the stored Data's value.
    public fun modify_value(s: signer, new_val: u8) {
        let address = signer::address_of(&s);
        let data_ref_mut = borrow_global_mut<Data>(address);
        data_ref_mut.value = new_val;
    }

    /// A function that creates a NoKeyData resource but does not store it globally.
    public fun create_nokey_value(val: u8): NoKeyData {
        NoKeyData {data: val}
    }

    /// A "runner" function that exercises several functionalities.
    public fun run_all(s: signer) {
        create_data(s, 42u64, 10u8);
        let value_before = read_value(s);
        modify_value(s, 20u8);
        let value_after = read_value(s);
        let _ = inline_adder(5u8, 7u8);
        // Native function call ignored here because it's native and not implemented.
        let _nokey = create_nokey_value(99u8);
        // The function does not return anything.
    }
}

//# run 0xCAFE::KeyAndFunctionsTest::create_data --signers 0xBABA --args 123u64 7u8

//# run 0xCAFE::KeyAndFunctionsTest::read_value --signers 0xBABA

//# run 0xCAFE::KeyAndFunctionsTest::modify_value --signers 0xBABA --args 42u8

//# run 0xCAFE::KeyAndFunctionsTest::read_value --signers 0xBABA

//# run 0xCAFE::KeyAndFunctionsTest::inline_adder --args 20u8 22u8

//# run 0xCAFE::KeyAndFunctionsTest::create_nokey_value --args 55u8

//# run 0xCAFE::KeyAndFunctionsTest::run_all --signers 0xBABA

// Featurres:
// 048eb77e16a691f25cb000b2451938a6: Use the 'Key' ability to designate values as keys for tables or collections.
// 3be5c5b2d436a95950a6921062710e99: Define functions in modules, specifying whether they are inline or native, and include optional bodies.
// 1be00abfa8dd1afb484fb692979d20e3: Implement functions within modules to encapsulate behavior.
