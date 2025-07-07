// Feature 1: Ensure resources acquired are from the same module as the function
// Feature 2: Mutate fields of dotted expressions directly
// Feature 3: Declare 'pragma friend' in spec blocks

//-------------------------------
//# publish
module 0xCAFE::ResourceTest {
    use std::signer;
    use std::assert;

    struct MyResource has key, store {
        value: u64,
    }

    public fun create_resource(account: &signer, val: u64) {
        move_to(account, MyResource { value: val });
    }

    public fun get_value(addr: address): u64 acquires MyResource {
        let res = borrow_global<MyResource>(addr);
        res.value
    }

    public fun mutate_value(addr: address, new_val: u64) acquires MyResource {
        let res = borrow_global_mut<MyResource>(addr);
        // Mutate dotted expression field directly
        res.value = new_val;
    }

    public fun remove_resource(account: &signer) acquires MyResource {
        move_from<MyResource>(signer::address_of(account));
    }

    // Runner for test
    public fun runner(account: &signer) acquires MyResource {
        Self::create_resource(account, 10);
        Self::mutate_value(signer::address_of(account), 123);
        let val = Self::get_value(signer::address_of(account));
        assert!(val == 123, 100);
        Self::remove_resource(account);
    }
}
//# run 0xCAFE::ResourceTest::runner --signers 0xCAFE

//-------------------------------
//# publish
module 0xCAFE::ResourceTest2 {
    use 0xCAFE::ResourceTest;
    use std::signer;

    public fun runner2(account: &signer) {
        // This can invoke ResourceTest functions, but not acquire acquires resource directly
        // Instead, test legal invocation
        ResourceTest::create_resource(account, 77);
        let _ = ResourceTest::get_value(signer::address_of(account));
        ResourceTest::remove_resource(account);
    }
}
//# run 0xCAFE::ResourceTest2::runner2 --signers 0xCAFE

//-------------------------------
//# publish
module 0xCAFE::FieldMutation {
    use std::assert;

    struct Container has store {
        x: u64,
        y: u8,
    }

    public fun mutate_struct_fields(c: &mut Container, new_x: u64, new_y: u8) {
        c.x = new_x;
        c.y = new_y;
    }

    public fun runner() {
        let c = Container { x: 1, y: 2 };
        let mut c = c;
        Self::mutate_struct_fields(&mut c, 55, 77);
        assert!(c.x == 55, 101);
        assert!(c.y == 77, 102);
    }
}
//# run 0xCAFE::FieldMutation::runner

//-------------------------------
//# publish
module 0xCAFE::FriendPragma {
    struct Dummy has drop, copy {}

    public fun dummy_func(): u8 { 5 }

    spec module {
        friend 0xCAFE::ResourceTest;
        friend 0xCAFE::ResourceTest2;
        friend 0xCAFE::FieldMutation;

        // simple spec statement to exercise spec block
        fun dummy_func_spec()
            ensures dummy_func() == 5;
    }
}

// Features:
// 47f2bdb37b9afaf1f74586a288d0e278: Ensure that resources acquired are from the same module as the function, preventing acquisition of resources from other modules
// 2e88e719c2a4a03015f635a5bd3e72e9: Mutate fields of dotted expressions directly.
// d01ac4476346f246f57908ea0b800590: Declare 'pragma friend' directives in spec blocks to specify friend modules for verification purposes.