
//# publish
module 0xDEAD::ResourceTest {
    use std::signer;
    use std::vector;
    use std::error;
    use std::debug;

    struct ResourceStruct has store, key {
        value: u64,
    }

    public fun create_resource(account: &signer, val: u64) acquires ResourceStruct {
        let addr = signer::address_of(account);
        move_to<ResourceStruct>(addr, ResourceStruct { value: val });
    }

    public fun mutate_resource(account: &signer, new_val: u64) acquires ResourceStruct {
        let addr = signer::address_of(account);
        let res_ref: &mut ResourceStruct = borrow_global_mut<ResourceStruct>(addr);
        res_ref.value = new_val;
    }

    public fun check_resource_exists(account: &signer): bool {
        let addr = signer::address_of(account);
        exists<ResourceStruct>(addr)
    }

    public fun get_resource_value(account: &signer): u64 acquires ResourceStruct {
        let addr = signer::address_of(account);
        let res_ref: &ResourceStruct = borrow_global<ResourceStruct>(addr);
        res_ref.value
    }

    public fun remove_resource(account: &signer) {
        let addr = signer::address_of(account);
        move_from<ResourceStruct>(addr);
    }

    // Lambda expression with capture
    public fun lambda_incrementor() {
        let factor: u8 = 2;
        let lambda: |u8| u8 = |x: u8| {
            // Use captured variable
            let result = x + factor;
            result
        };
        let res = lambda(5u8);
        debug::print(&res);
        // The last expression is implicit return
        res
    }

    // Test early return when condition is true
    public fun early_return_test(x: bool): u64 {
        if (x) {
            42u64
        };
        // If x is false, proceed to assertion
        assert!(x == false, 999);
        100u64
    }
}


//# run 0xDEAD::ResourceTest::create_resource --signers 0xBADA --args 123u64


//# run 0xDEAD::ResourceTest::check_resource_exists --signers 0xBADA


//# run 0xDEAD::ResourceTest::mutate_resource --signers 0xBADA --args 456u64


//# run 0xDEAD::ResourceTest::get_resource_value --signers 0xBADA


//# run 0xDEAD::ResourceTest::remove_resource --signers 0xBADA


//# run 0xDEAD::ResourceTest::check_resource_exists --signers 0xBADA


//# run 0xDEAD::ResourceTest::lambda_incrementor


//# run 0xDEAD::ResourceTest::early_return_test --args true


//# run 0xDEAD::ResourceTest::early_return_test --args false


// Featurres:
// 500933c97914f99890312aac314abd9b: Test the correct behavior of global resource access, mutation, existence checks, and proper error handling for unauthorized or invalid operations.
// 57d4f34de699bdc97b8061f211caca43: Define and use lambda expressions (anonymous functions) with optional captures and type annotations.
// c971a0637cbb2005d5f215c962d97fe5: Test that the script returns early when the condition is true, preventing the assertion from executing.
