//# publish
module 0xCAFE::NameAccess {
    use std::signer;

    struct InnerStruct has store, copy, drop {
        val: u64,
    }

    struct OuterStruct has store, copy, drop {
        inner: InnerStruct,
    }

    public fun create_struct(s: signer, val: u64): OuterStruct {
        let inner = InnerStruct { val };
        OuterStruct { inner }
    }

    public fun get_inner_value(os: &OuterStruct): u64 {
        os.inner.val
    }

    // Spec function without body (native spec function)
    native spec fun native_spec_fun(): bool;

    // Spec function with body (defined spec function)
    spec fun defined_spec_fun(x: u64): u64 {
        x + 1
    }

    public fun call_defined_spec_fun(x: u64): u64 {
        defined_spec_fun(x)
    }
}

//# run 0xCAFE::NameAccess::create_struct --signers 0xBADA --args 123u64

//# run 0xCAFE::NameAccess::get_inner_value --args 0xCAFE::NameAccess::OuterStruct { inner: 0xCAFE::NameAccess::InnerStruct { val: 123u64 } }

//# run 0xCAFE::NameAccess::call_defined_spec_fun --args 99u64


//# publish 0xCAFE
module StorageAndSpec {
    use std::signer;

    struct Data has store, key {
        data_field: u32,
    }

    public fun init_data(s: signer, val: u32) {
        move_to<Data>(&s, Data { data_field: val });
    }

    public fun update_data(s: signer, val: u32) {
        let mut_ref = borrow_global_mut<Data>(signer::address_of(&s));
        mut_ref.data_field = val;
    }

    public fun read_data(s: signer): u32 {
        let ref = borrow_global<Data>(signer::address_of(&s));
        ref.data_field
    }

    // Native spec function declaration (no body)
    native spec fun native_counter(x: u32): u32;

    // Defined spec function (with body)
    spec fun increment_counter(x: u32): u32 {
        x + 1
    }

    public fun use_increment(x: u32): u32 {
        increment_counter(x)
    }
}

//# run 0xCAFE::StorageAndSpec::init_data --signers 0xBADE --args 777u32

//# run 0xCAFE::StorageAndSpec::read_data --signers 0xBADE

//# run 0xCAFE::StorageAndSpec::update_data --signers 0xBADE --args 888u32

//# run 0xCAFE::StorageAndSpec::read_data --signers 0xBADE

//# run 0xCAFE::StorageAndSpec::use_increment --args 123u32


//# publish
module 0xCAFE::ExplicitAddressModule {
    use std::vector;

    struct ExplicitStruct has copy, drop, store {
        arr: vector<u8>
    }

    public fun create_with_data(): ExplicitStruct {
        let arr = vector[10u8, 20u8, 30u8];
        ExplicitStruct { arr }
    }

    public fun length(s: &ExplicitStruct): u64 {
        vector::length(&s.arr)
    }
}

//# run 0xCAFE::ExplicitAddressModule::create_with_data

//# run 0xCAFE::ExplicitAddressModule::length --args 0xCAFE::ExplicitAddressModule::ExplicitStruct { arr: vector[10u8, 20u8, 30u8] }

// Featurres:
// 5d58de1bdef35f9deb9eb5006bf9ebc8: Write names that are accessed through chains of identifiers, such as module and struct accesses (e.g., Module::Struct).
// 40dd5f2d2d0593977243d4dde78a926d: Choose between native spec functions (no body) and defined spec functions (with a statement sequence body).
// 17ff4d5772fb0424b7dea7332fe27329: Define Move modules with or without specifying an explicit address block.
