
//# publish
module 0xDEAD::ResourceTest {
    use std::signer;
    // Removed unused 'use std::vector;' and 'use std::error;'
    use std::debug; // 'debug' module exists in standard Move library

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
        // In Move, explicit return is required if not last line, so add 'res;' if needed
        // But since function has no return, this is just for debugging
        // No return value necessary
    }

    // Test early return when condition is true
    public fun early_return_test(x: bool): u64 {
        if (x) {
            42u64
        } else {
            // In Move, 'if' expressions should have explicit else
            // So rewrite as:
            if (x) {
                42u64
            } else {
                // The assertion is only reached if x == false
                assert!(x == false, 999);
                100u64
            }
        }
        // But notice that in original code, 'if' without 'else' is invalid in Move
        // Therefore, rewrite accordingly
        // Return the value from if-else
        // example:
        if (x) {
            42u64
        } else {
            assert!(x == false, 999);
            100u64
        }
        // Move functions need to explicitly return, so assign to a variable if needed
        // but since the function returns u64, just return the if expression
        // So, rewrite as:
        // return if (x) { 42 } else { ... }
    }

    // Corrected 'early_return_test'
    public fun early_return_test(x: bool): u64 {
        if (x) {
            42u64
        } else {
            assert!(x == false, 999);
            100u64
        }
    }
}
