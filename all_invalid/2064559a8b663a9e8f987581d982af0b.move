
//# publish
module 0xCAFE::ResourceManagement {
    resource struct MyResource {
        value: u64,
    }

    public fun create_resource(account: &signer, init_value: u64) {
        let resource = MyResource { value: init_value };
        move_to(account, resource);
    }

    public fun get_resource_value(addr: address): u64 {
        borrow_global<MyResource>(addr).value
    }

    public fun borrow_resource_value(account: &signer): u64 {
        borrow_global<MyResource>(signer::address_of(account)).value
    }

    public fun mutate_resource(account: &signer, delta: u64) {
        let resource = borrow_global_mut<MyResource>(signer::address_of(account));
        resource.value = resource.value + delta;
    }

    public fun remove_resource(account: &signer): MyResource {
        move_from<MyResource>(signer::address_of(account))
    }

    public fun process_vector(vec: &mut vector<u8>) {
        let len = vector::length(vec);
        let i = 0;
        while (i < len) {
            let val = *vector::borrow(vec, i);
            if val % 2 == 0 {
                vector::push_back(vec, val + 1);
            } else {
                vector::push_back(vec, val);
            }
            i = i + 1;
        }
    }
}


//# publish
module 0xCAFE::LoopAndBorrow {
    use 0xCAFE::ResourceManagement;

    public fun loop_with_label() {
        let vec = vector::empty<u8>();
        let vec_ref = &mut vec;

        // Creating initial vector
        vector::push_back(vec_ref, 1);
        vector::push_back(vec_ref, 2);
        vector::push_back(vec_ref, 3);

        'outer: for i in 0..3 {
            if i == 1 {
                break 'outer;
            }
            ResourceManagement::process_vector(vec_ref);
        }

        assert!(vector::length(vec_ref) >= 3, 0);
    }

    public fun borrow_and_mutate(account: &signer) {
        // create resource
        ResourceManagement::create_resource(account, 10);
        // borrow immutable
        let val = ResourceManagement::borrow_resource_value(account);
        assert!(val == 10, 0);
        // mutate resource
        ResourceManagement::mutate_resource(account, 5);
        let new_val = ResourceManagement::borrow_resource_value(account);
        assert!(new_val == 15, 0);
    }

    public fun remove_and_check(account: &signer) {
        let resource = ResourceManagement::remove_resource(account);
        assert!(resource.value >= 10, 0);
        // resource is no longer available in storage
    }
}


//# run 0xCAFE::ResourceManagement::create_resource --signers 0xBEEF --args 42u64


//# run 0xCAFE::LoopAndBorrow::loop_with_label


//# run 0xCAFE::LoopAndBorrow::borrow_and_mutate --signers 0xBEEF


//# run 0xCAFE::LoopAndBorrow::remove_and_check --signers 0xBEEF