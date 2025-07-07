//# publish
module 0xCAFE::AccessControl {
    use std::signer;

    // A generic resource with a value of generic type T
    resource struct Container<T> {
        value: T,
        owner: address,
    }

    // Store Container resource under a specific address
    public fun init_container<T: store>(account: &signer, val: T) {
        move_to(account, Container<T> { value: val, owner: signer::address_of(account) });
    }

    // Generic getter, controls read access
    #[lint(skip = "access_control")]
    public fun get_value<T: store>(
        addr: address,
        permission_fn: &fun(addr: address, resource_type: type): bool
    ): T acquires Container<T> {
        // Check permission before borrow
        if (!permission_fn(addr, type_of<Container<T>>())) {
            abort 1;
        };
        let container_ref = borrow_global<Container<T>>(addr);
        container_ref.value
    }

    // Generic setter, controls write access
    #[lint(skip = "access_control")]
    public fun set_value<T: store>(
        account: &signer,
        permission_fn: &fun(addr: address, resource_type: type): bool,
        new_value: T
    ) acquires Container<T> {
        let addr = signer::address_of(account);
        // Check permission before borrow_mut
        if (!permission_fn(addr, type_of<Container<T>>())) {
            abort 2;
        };
        let container_ref = borrow_global_mut<Container<T>>(addr);
        container_ref.value = new_value;
    }
}

//# run
script {
    use 0xCAFE::AccessControl;
    use std::signer;
    use std::vector;

    fun permission_allow(_addr: address, _res_type: type): bool {
        // For testing, allow read/write for every address and resource type
        true
    }

    fun main(s: &signer) {
        // Initialize a Container with a u64 value
        AccessControl::init_container(s, 42u64);

        // Get the address
        let addr = signer::address_of(s);

        // Use generic get_value with permission function
        let val: u64 = AccessControl::get_value(addr, &permission_allow);
        // Do nothing with val, just testing access

        // Use generic set_value to change value
        AccessControl::set_value(s, &permission_allow, 100u64);

        // Verify change by getting again
        let new_val: u64 = AccessControl::get_value(addr, &permission_allow);
        // Do nothing further
    }
} 

//# run 0xCAFE::AccessControl::main --signers 0xBADD
//# run 0xCAFE::AccessControl::get_value --signers 0xBADD --args 0xBADD
//# run 0xCAFE::AccessControl::set_value --signers 0xBADD --args 0xBADD 77u64

//# publish
module 0xCAFE::LintTest {
    // Testing the lint skip attribute on a struct
    #[lint(skip = "foo")]
    struct Foo {
        x: u64,
        y: u64,
    }

    // Test with a function also skipping lint
    #[lint(skip = "bar")]
    public fun dummy() {
        // No operation
    }
}

//# run 0xCAFE::LintTest::dummy

//# publish
module 0xCAFE::LoopTest {
    // Test break and continue with labels
    public fun run_loops() {
        let i = 0;
        'outer: loop {
            i = i + 1;
            if (i > 10) {
                break 'outer;
            }
            if (i % 2 == 0) {
                // Continue the outer loop, skipping remaining code
                continue 'outer;
            }
            // Do something for odd i
            // (No actual operation)
        }

        // Nested loop with labels
        let j = 0;
        'nested: loop {
            j = j + 1;
            let k = 0;
            'inner: loop {
                if (k >= 3) {
                    break 'inner;
                }
                if (j > 5) {
                    break 'nested;
                }
                k = k + 1;
            }
            if (j >= 8) {
                break 'nested;
            }
        }
    }
}

//# run 0xCAFE::LoopTest::run_loops

// Featurres:
// aaa620358010856cd032313ad4729102: Use the #[lint(skip = ...)] attribute to specify Move lint checks to skip for a particular code item.
// d24f22da4df48d58f1ad9e427550008c: Test that generic access control using function values enables permissioned read and write operations on any resource type without embedding access logic within each resource.
// f928cd373a4c5af443bc04af0e5c35a0: Use `break` and `continue` statements with optional labels.
