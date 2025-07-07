
//# publish
module 0xC0DE::TestInteraction {
    use std::signer;
    use std::vector;

    // 1. Basic module function to call from script
    public fun module_func(): u64 {
        42u64
    }

    // 2. Function demonstrating local variables outside and inside while loop
    public fun variable_shadowing_test(): (u64, u64) {
        let outer_var = 100u64;
        let inner_var = 0u64;
        let counter = 0u64;

        while (counter < 3) {
            let outer_var = counter * 10u64; // shadow outer_var
            inner_var = outer_var + 1u64;
            counter = counter + 1u64;
        };
        (outer_var, inner_var)
    }

    // 3. Resource with internal visibility
    struct SecretResource has key {
        secret_value: u128,
    }

    // Internal function to create resource (accessible only within module)
    fun create_secret(s: signer, value: u128) {
        let resource = SecretResource { secret_value: value };
        move_to<SecretResource>(&s, resource);
    }

    // Public function to invoke internal creation
    public fun create_secret_public(s: signer, value: u128) {
        create_secret(s, value);
    }

    // Function to access resource (for testing purpose, should only be called internally)
    fun get_secret(s: &signer): u128 {
        let res_ref: &SecretResource = borrow_global<SecretResource>(signer::address_of(s));
        res_ref.secret_value
    }

    // 4. Numeric literals for various types
    public fun numeric_literals(): (u8, u16, u32, u64, u128) {
        (255u8, 65535u16, 4294967295u32, 18446744073709551615u64, 340282366920938463463374607431768211455u128)
    }

    // 5. Conflicting expected failure annotation with location info
    // expected_failure(location=42)]
    public fun fail_literal_overflow(): u8 {
        // deliberately cause overflow (for test purpose, assume function is supposed to fail)
        let overflow_value = 300u8; // u8 max is 255, so 300 overflows
        overflow_value
    }

    // 6. Access module info during runtime (simulated via a function that returns module name)
    public fun get_module_name(): vector<u8> {
        b"0xC0DE::TestInteraction"
    }
}

// Script entry point to test module functions and behaviors

//# run
script {
    use 0xC0DE::TestInteraction;

    // Call module_basic function and check return
    let val = TestInteraction::module_func();

    // Variable shadowing test
    let (outer, inner) = TestInteraction::variable_shadowing_test();

    // Create secrets resource
    let addr = signer::address_of(&signer::default_sender());
    let s = signer::borrow(&signer::default_signer());
    TestInteraction::create_secret_public(s, 999u128);
    let secret_value = TestInteraction::get_secret(&s);

    // Numeric literals test
    let (byte8, short16, int32, long64, big128) = TestInteraction::numeric_literals();

    // Attempt to invoke function with expected failure (simulate compiler error)
    // The actual testing framework would capture the expected failure at compile time
    // but we include it here for completeness.
    let _ = TestInteraction::fail_literal_overflow();

    // Fetch module name
    let module_name_bytes = TestInteraction::get_module_name();

    // The variables constructed above can be further evaluated or asserted in a comprehensive test suite
};


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 50491a6bc8926e957907e98af5cd840d: Write number literals for integer and numeric values within the allowable size for their type.
// 9df22a99e19c0bc0af7a6e7e53a12d34: Attach a location to the expected failure by providing a `location` attribute within the `#[expected_failure]` attribute, either as a constant or a specific location value.
// badd4e0be5e51c0863927e34e8c8deb5: Access module information within unpacked structs.
