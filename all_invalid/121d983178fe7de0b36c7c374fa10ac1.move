
//# publish
module 0xCAFE::FilterConstants {
    use std::signer;

    /// A helper struct for script constants storage
    struct ConstHolder has key, store {
        val: u8
    }

    // Function: add constant as resource to signer (simulate adding constant)
    public fun add_constant(s: signer, v: u8) {
        let ch = ConstHolder { val: v };
        move_to<ConstHolder>(&s, ch);
    }

    // Function: remove constant resource from signer (simulate removing constant)
    public fun remove_constant(s: signer) {
        let ch = move_from<ConstHolder>(signer::address_of(&s));
        let ConstHolder { val: _ } = ch;
    }

    // Function: inspect constant resource value for filtering test
    public fun get_constant_value(s: signer): u8 {
        let ch_ref = borrow_global<ConstHolder>(signer::address_of(&s));
        ch_ref.val
    }

    // Function: runner with no args that adds and removes to test filtering logic
    public fun run_filter_test(s: signer) {
        add_constant(s, 100);
        let _v = get_constant_value(s);
        remove_constant(s);
    }
}




//# run 0xCAFE::FilterConstants::run_filter_test --signers 0xBEEF




//# publish
module 0xCAFE::ImportedModules {
    use std::vector;

    // Function to test vector module import and usage
    public fun create_and_push_vector(): vector<u8> {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 42);
        vector::push_back(&mut v, 24);
        v
    }
}



//# run 0xCAFE::ImportedModules::create_and_push_vector




//# publish
module 0xCAFE::OptimizeBytecode {
    use std::signer;

    // A struct with some operations for optimizer test
    struct Data has key, store {
        a: u64,
        b: u64,
    }

    // Store resource Data with specific values (simulate storing after optimization pass)
    public fun store_data(s: signer) {
        let data = Data {a: 10, b: 20};
        move_to<Data>(&s, data);
    }

    // Update Data's fields to test optimizer can handle mutations
    public fun update_data(s: signer) {
        let data_ref = borrow_global_mut<Data>(signer::address_of(&s));
        data_ref.a = data_ref.a + 5;
        data_ref.b = data_ref.b * 2;
    }

    // Runner that stores and updates data to test optimizer passes
    public fun run_optimize_test(s: signer) {
        store_data(s);
        update_data(s);
    }
}




//# run 0xCAFE::OptimizeBytecode::run_optimize_test --signers 0xCAFE
