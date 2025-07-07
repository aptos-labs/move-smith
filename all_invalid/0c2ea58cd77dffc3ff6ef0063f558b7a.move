//# publish
module 0xC0FF::TestModule {
    use std::signer;
    use std::option;

    struct R has key {
        data: u64,
    }

    public fun acquire_resource(s: &signer): () acquires R {
        let r = R { data: 42 };
        move_to<R>(s, r);
    }

    public fun get_resource_data(addr: address): option::Option<u64> {
        if (exists<R>(addr)) {
            let r_ref: &R = borrow_global<R>(addr);
            option::some(r_ref.data)
        } else {
            option::none()
        }
    }

    public fun test_acquire_and_get(s: &signer): bool {
        let addr = signer::address_of(s);
        acquire_resource(s);
        let data_opt = get_resource_data(addr);
        // Check that resource exists and data is correct
        if (option::is_some(&data_opt)) {
            let data = *option::extract(&data_opt);
            data == 42
        } else {
            false
        }
    }

    public fun tester(x: bool, y: bool): u8 {
        let result: u8 = 0;
        if (x && y) {
            result = result + 1;
        } else {
            result = result + 2;
        };
        if (x || y) {
            result = result + 4;
        } else {
            result = result + 8;
        };
        result
    }

    // Helper function to call tester with specific booleans
    public fun run_tester_with_booleans(b1: bool, b2: bool): u8 {
        tester(b1, b2)
    }
}
