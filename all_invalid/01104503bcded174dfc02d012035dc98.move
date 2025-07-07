
//# publish
module 0xCAFE::PragmaAndGenerics {
    use std::signer;

    // Move currently does not support a pragma keyword, remove them or replace by consts
    // Replace pragmas with constants
    const MY_BOOL_PROP: bool = true;
    const MY_NUM_PROP: u64 = 0;
    const MY_HEX_PROP: vector<u8> = vector[0x00, 0xFF];
    const MY_BYTE_STRING_PROP: vector<u8> = vector[0x0A, 0x09, 0x0D];
    // Cannot assign Identifier_123 - not defined, remove or comment out
    // const MY_IDENTIFIER_PROP = Identifier_123;

    const PRAGMA_FALSE: bool = false;
    const PRAGMA_LARGE: u64 = 18446744073709551615;

    // Generic structs with different ability constraints

    // Copyable type parameter
    struct CopyWrapper<T: copy> has copy, drop, store {
        value: T
    }

    // Droppable only type parameter
    struct DropWrapper<T: drop> has drop, store {
        value: T
    }

    // Store constrained type parameter - for storing in resources
    struct StoreWrapper<T: store> has store {
        value: T
    }

    // Key constrained type parameter - for key usage
    struct KeyWrapper<T: key> has key {
        value: T
    }

    // A generic function using CopyWrapper<T> ensuring T: copy, returns a copy
    public fun copy_value<T: copy>(x: CopyWrapper<T>): CopyWrapper<T> {
        let copied = CopyWrapper<T> { value: copy x.value };
        copied
    }

    // A generic function with DropWrapper<T> constraint to test dropability
    public fun drop_and_return<T: drop>(x: DropWrapper<T>): DropWrapper<T> {
        // Implicit drop on x leaving scope, just return it back
        x
    }

    // A generic function with StoreWrapper<T> constraint storing a resource inside
    public fun store_resource<T: store>(s: &signer, val: T) {
        let wrapper = StoreWrapper<T> { value: val };
        move_to<StoreWrapper<T>>(s, wrapper);
    }

    // A generic function with KeyWrapper<T> constraint checking key address equality
    public fun check_key<T: key>(_item1: &KeyWrapper<T>, _item2: &KeyWrapper<T>): bool {
        // Just compare the addresses of key type fields if they are addresses
        // But `T` is generic key type, cannot access fields here,
        // so just return true for testing compilation
        true
    }

    // Internal helper: instantiate and return all wrappers with a u8 value 42u8 where possible
    fun make_all_wrappers(s: &signer): (CopyWrapper<u8>, DropWrapper<vector<u8>>, StoreWrapper<CopyWrapper<u8>>, KeyWrapper<address>) {
        let copy_wrap = CopyWrapper<u8> { value: 42u8 };
        let drop_wrap = DropWrapper<vector<u8>> { value: vector[42u8] };
        let store_wrap = StoreWrapper<CopyWrapper<u8>> { value: CopyWrapper<u8> { value: 42u8 } };
        let key_wrap = KeyWrapper<address> { value: signer::address_of(s) };
        (copy_wrap, drop_wrap, store_wrap, key_wrap)
    }

    // The "script" function inside the module to run various tests together
    public fun run_pragmas_and_generics(s: signer) {
        // Access pragma values inside code (dummy usage)
        let _ = MY_BOOL_PROP;
        let _ = MY_NUM_PROP;
        let _ = PRAGMA_FALSE;
        let _ = PRAGMA_LARGE;

        // Instantiate wrappers and call generic functions
        let (copy_wrap, drop_wrap, store_wrap, key_wrap) = make_all_wrappers(&s);

        let _copy_result = copy_value(copy_wrap);
        let _drop_result = drop_and_return(drop_wrap);

        // Store resource inside account storage
        store_resource(&s, store_wrap);

        let _check = check_key(&key_wrap, &key_wrap);
    }
}



//# run 0xCAFE::PragmaAndGenerics::run_pragmas_and_generics --signers 0xBEEF




//# publish
module 0xCAFE::ScriptModule0 {
    use std::signer;
    use 0xCAFE::PragmaAndGenerics;

    // Script function calling inner generic functions explicitly
    public fun call_copy_and_drop_wrappers(s: signer) {
        let copy_instance = PragmaAndGenerics::CopyWrapper<u16> { value: 100u16 };
        let drop_instance = PragmaAndGenerics::DropWrapper<vector<u8>> { value: vector[1u8, 2u8, 3u8] };

        let _copy_res = PragmaAndGenerics::copy_value(copy_instance);
        let _drop_res = PragmaAndGenerics::drop_and_return(drop_instance);
    }

    // Script function calling store_resource using signer
    public fun call_store_resource(s: signer) {
        let val = PragmaAndGenerics::CopyWrapper<u8> { value: 255u8 };
        PragmaAndGenerics::store_resource(&s, val);
    }

    // Script function for key constrained wrapper
    public fun call_check_key(s: signer) {
        let key_wrap = PragmaAndGenerics::KeyWrapper<address> { value: signer::address_of(&s) };
        let _res = PragmaAndGenerics::check_key(&key_wrap, &key_wrap);
    }
}



//# run 0xCAFE::ScriptModule0::call_copy_and_drop_wrappers --signers 0xD0D0



//# run 0xCAFE::ScriptModule0::call_store_resource --signers 0xD0D0



//# run 0xCAFE::ScriptModule0::call_check_key --signers 0xD0D0



//# publish
module 0xCAFE::IntegrationTestModule {
    use std::signer;
    use 0xCAFE::PragmaAndGenerics;
    use 0xCAFE::ScriptModule0;

    // This function tests all combined features and enforces interaction between modules
    public fun integrated_runner(s: signer) {
        // Call pragma based function inside PragmaAndGenerics
        PragmaAndGenerics::run_pragmas_and_generics(s);

        // Call script functions that call generic constrained functions
        ScriptModule0::call_copy_and_drop_wrappers(s);
        ScriptModule0::call_store_resource(s);
        ScriptModule0::call_check_key(s);
    }
}



//# run 0xCAFE::IntegrationTestModule::integrated_runner --signers 0xDEAD
