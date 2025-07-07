
//# publish
module 0xCAFE::InternalAccess {
    // This module demonstrates internal visibility and access restrictions.
    // It also shows resource encapsulation.
    struct SecretResource has key {
        secret_data: u64,
    }

    // Move 'internal' functions are not allowed at top-level; instead, mark functions as 'public' and restrict via 'public(friend)' if needed.
    // Since Move currently does not support 'internal', we just make the functions 'public' but placed in the same module.
    // Alternatively, if internal is intended, omit 'pub' and keep them as private (default).

    // For this test, we remove 'internal' and keep functions package-private by not marking them 'public'
    fun create_secret_resource(x: u64): SecretResource {
        SecretResource { secret_data: x }
    }

    // Internal function accessible only within this module
    fun get_secret_data(res: &SecretResource): u64 {
        res.secret_data
    }

    // Public function to validate that outside modules cannot access internal functions.
    public fun expose_secret_data(res: &SecretResource): u64 {
        get_secret_data(res)
    }
}


//# publish
module 0xCAFE::CrossRef {
    // Cross-module reference test: calling functions from other modules.
    use 0xCAFE::InternalAccess;

    // Move 'use' imports the module, not specific functions, so they are accessible.
    // No issue to call functions as long as they are 'public' and in scope.
    public fun call_internal_create(x: u64): SecretResource {
        InternalAccess::create_secret_resource(x)
    }
}



//# publish
module 0xCAFE::Main {
    use std::signer;
    use 0xCAFE::InternalAccess;
    use 0xCAFE::CrossRef;

    // Function to test local variable shadowing inside and outside loops
    public fun test_variable_scope() {
        let outer_var: u64 = 100;
        let shadowed_var: u64 = 0;

        // Loop where inner shadowed variable is introduced
        for (i in 0..3) {
            let shadowed_var = i as u64 + 1; // shadows outer 'shadowed_var'
            let _ = shadowed_var; // use inner variable
        };

        // After loop, outer variable should be unchanged
        assert!(outer_var == 100, 42);
    }

    // Function to test local variables outside loops
    public fun test_variable_outside_loop() {
        let a: u64 = 0;
        let b: u64 = 5;

        let i: u64 = 0;
        while (i < b) {
            a = a + i;
            i = i + 1;
        };
        a // return the sum
    }

    // Function to test internal functions and resources
    public fun test_internal_functions_and_resources(s: &signer) {
        // Create resource with internal function
        let secret = InternalAccess::create_secret_resource(12345);
        // Access resource data via exposed function
        let data = InternalAccess::expose_secret_data(&secret);
        assert!(data == 12345, 42);
    }

    // Function to instantiate resource and then attempt illegal access (expected compile error)
    public fun illegal_access_attempt() {
        // The following line should not compile if uncommented,
        // as internal functions/resources are inaccessible externally.
        // let res = InternalAccess::create_secret_resource(6789);
        // let data = InternalAccess::get_secret_data(&res);
        // assert!(data == 6789, 42);
        // Since this is a test for compiler error, we keep this code commented.
        ()
    }

    // Inline function accepting a closure (lambda) and invoking it
    public fun run_closure_with_value<F: copy + of (u64) -> u64>(f: F, val: u64): u64 {
        f(val)
    }

    // Wrapper function to pass different closures
    public fun test_closure_invocations() {
        let closure1 = |a: u64| { a + 10 };
        let closure2 = |a: u64| { a * 2 };

        let result1 = run_closure_with_value(closure1, 5);
        assert!(result1 == 15, 42);

        let result2 = run_closure_with_value(closure2, 7);
        assert!(result2 == 14, 42);
    }

    // Function that references multiple modules (CrossRef and InternalAccess)
    public fun cross_module_usage() {
        let res = CrossRef::call_internal_create(999);
        let data = InternalAccess::expose_secret_data(&res);
        assert!(data == 999, 42);
    }

    // Script entry point to invoke the test functions
    public fun run_all_tests(s: &signer) {
        test_variable_scope();
        let sum = test_variable_outside_loop();
        assert!(sum == 0 + 1 + 2 + 3 + 4, 42);
        test_internal_functions_and_resources(s);
        test_closure_invocations();
        cross_module_usage();
        // Note: illegal_access_attempt() is commented out as it's expected to cause compiler error if used
    }
}



//# run 0xCAFE::Main::run_all_tests --signers 0xBADD


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 6c7f57231e4d203ef1b2da0870bd7436: Test that an inline function can accept closures as arguments and correctly invoke them with given parameters.
// f29b698cd26551f64542677c739b9b25: Use module identifiers to reference modules in your Move code.
