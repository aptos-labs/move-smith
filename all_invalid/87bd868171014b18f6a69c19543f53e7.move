
//# publish
module 0xCAFE::GenericStructTest {
    use std::vector;

    // Declare a constant with a specific name and value
    const TEST_CONST: u64 = 987654321;

    // Define a generic struct that can be stored
    struct GenStruct<T> has store, key {
        value: T,
    }

    // Define a module that interacts with the generic struct
    public fun create_and_store_generic_struct<T: copy + drop + store>(
        addr: address,
        val: T
    ) {
        let gen_struct = GenStruct { value: val };
        move_to<GenStruct<T>>(&signer::borrow_address(addr), gen_struct);
    }

    public fun get_generic_struct<T: copy + drop + store>(addr: address): GenStruct<T> {
        borrow_global<GenStruct<T>>(addr)
    }

    // Function to mutate the stored generic struct
    public fun mutate_generic_struct_value<T: copy + drop + store>(
        addr: address,
        new_value: T
    ) {
        let g_struct_mut: &mut GenStruct<T> = borrow_global_mut<GenStruct<T>>(addr);
        g_struct_mut.value = new_value;
    }

    // Function to check existence
    public fun exists(addr: address): bool {
        exists<GenStruct<u8>>(addr)
    }
}


//# publish
module 0xCAFE::ConstantsAndVariables {
    use std::signer;

    // Public constant with a specific name and value
    public const MY_CONSTANT: u16 = 0xABCD;

    // A mutable global resource that holds an u8 value
    struct GlobalCounter has store, key {
        count: u8,
    }

    // Initialize global counter at a specific address
    public fun init_counter(s: &signer) {
        move_to<GlobalCounter>(s, GlobalCounter { count: 0 });
    }

    // Function to mutate the global counter
    public fun increment_counter(s: &signer) {
        let counter_ref: &mut GlobalCounter = borrow_global_mut<GlobalCounter>(signer::address_of(s));
        counter_ref.count = counter_ref.count + 1;
    }

    // Function to read the counter
    public fun get_counter(addr: address): u8 {
        let counter: &GlobalCounter = borrow_global<GlobalCounter>(addr);
        counter.count
    }
}


//# run 0xCAFE::GenericStructTest::create_and_store_generic_struct --signers 0xBEEF --args 0xBEEF, 42u8


//# run 0xCAFE::GenericStructTest::get_generic_struct --args 0xBEEF


//# run 0xCAFE::GenericStructTest::mutate_generic_struct_value --signers 0xBEEF --args 0xBEEF, 100u8


//# run 0xCAFE::GenericStructTest::get_generic_struct --args 0xBEEF


//# run 0xCAFE::GenericStructTest::exists --args 0xBEEF


//# run 0xCAFE::ConstantsAndVariables::init_counter --signers 0xBEEF


//# run 0xCAFE::ConstantsAndVariables::get_counter --args 0xBEEF


//# run 0xCAFE::ConstantsAndVariables::increment_counter --signers 0xBEEF


//# run 0xCAFE::ConstantsAndVariables::get_counter --args 0xBEEF

// Featurres:
// 0189d3c651e54103130a64707b72129f: Test that creating and checking existence of generic structs in multiple modules, and passing them through functions, works correctly with storage, key management, and type parameters.
// 646d4127a24c340b4a97e5cc7f22b5a9: Define constants with specific names and values in Move modules.
// 17e32096043b947e097ce2fa11e19fc5: Perform assignments to local variables, struct fields, or perform mutate operations with the `assign` and `mutate` expressions.
