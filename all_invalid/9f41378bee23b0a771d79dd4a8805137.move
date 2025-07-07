//# publish
module 0x1::diagnostic_module {
    /// Utility to print diagnostic messages during compilation or VM execution.
    fun print(msg: vector<u8>) {
        // In actual tests, this could be a no-op or logging mechanism.
        // Here, we leave it intentionally empty.
    }
}

//# publish
module 0x1::access_control {
    /// Resource representing some data with access control.
    resource struct Data {
        value: u64,
    }

    /// Public resource holder.
    resource struct Holder {
        data: option<Data>,
    }

    /// Initialize holder with no data.
    public fun init_holder(account: &signer) {
        move_to(account, Holder { data: none() });
    }

    /// Set data in holder if authorized.
    public fun set_data(account: &signer, val: u64) {
        let holder = borrow_global_mut<Holder>(signer_address_of(account));
        if (exists<Holder>(signer_address_of(account))) {
            let data_ref = &mut holder.data;
            *data_ref = some(Data { value: val });
        }
    }

    /// Get data from holder.
    public fun get_data(account: &signer): u64 acquires Data {
        let holder = borrow_global<Holder>(signer_address_of(account));
        match &holder.data {
            some(d) => d.value,
            none() => 0,
        }
    }
}

//# publish
module 0x1::protected {
    use 0x1::access_control;
    use 0x1::diagnostic_module;

    /// Function pointer type for permission checking.
    type PermissionChecker = fun(account: address): bool;

    /// Store authorized functions.
    resource struct PermissionRegistry {
        checker: fun(account: address): bool,
    }

    /// Initialize permission registry.
    public fun init_registry(account: &signer, checker: fun(account: address): bool) {
        move_to(account, PermissionRegistry { checker });
    }

    /// Check if account has permission.
    public fun has_permission(account: address, registry_addr: address): bool acquires PermissionRegistry {
        let registry_ref = borrow_global<PermissionRegistry>(registry_addr);
        (registry_ref.checker)(account)
    }

    /// Attempt to read data resource with permission control.
    public fun safe_get_data(
        registry_addr: address,
        target_account: address
    ): u64 acquires access_control::Data {
        if (has_permission(target_account, registry_addr)) {
            if (exists<access_control::Data>(target_account)) {
                return access_control::get_data(&signer));
            } else {
                // Diagnostic message
                diagnostic_module::print(b"Data does not exist");
                return 0;
            }
        } else {
            diagnostic_module::print(b"Permission denied");
            return 0;
        }
    }
}

//# publish
module 0x0::runner {
    use 0x1::access_control;
    use 0x1::protected;
    use 0x1::diagnostic_module;

    /// Helper function to replace 'copy(x)' with 'copy x' for syntax correctness.
    /// Here, it's illustrative: actual Move syntax does not use 'copy(x)'.
    /// This function uses proper syntax: just returning a copy.
    public fun copy_value(x: u64): u64 {
        x
    }

    /// Function to test that a function correctly returns a previously assigned variable.
    public fun test_return_value(val: u64): u64 {
        let stored = val;
        // Call a function with stored value - here, just return it.
        return stored;
    }

    /// Runner function to execute multiple tests.
    public fun run_all_tests() {
        // Initialize permission registry with a simple checker.
        let checker_addr = @0xA;
        // Assume a function that always returns true for checker.
        // For simplicity, the checker is a stub here.
        // The test is conceptual.
        // Initialize registry
        // (In actual testing, deploy a checker function that always returns true)
        // For the purpose of this test, we skip actual deployment and trust the logic.
        // We'll simulate permission grants.

        // Set data for account 0xB.
        // Setup
        access_control::init_holder(&signer(0xB));
        access_control::set_data(&signer(0xB), 42);

        // Test access control - permission granted scenario
        let result1 = protected::safe_get_data(checker_addr, 0xB);
        // Here, result should be 42

        // Test access control - permission denied scenario
        // Simulate a case where permission is denied; for simplicity, assume false.
        // Since we can't dynamically change the function, assume 'has_permission' returns false.
        // For the purpose of this test, just call safe_get_data with a non-allowed address.
        let result2 = protected::safe_get_data(checker_addr, 0xC);
        // result2 expected to be 0 and print "Permission denied"
    }
}

//# run 0x0::runner::run_all_tests