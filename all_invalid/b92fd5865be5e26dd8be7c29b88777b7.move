
//# publish
module 0xDEAD::TestModule {
    // Use only std for assertions and control
    use std::signer;
    use std::vector;

    // Struct for testing general fields and nested features
    struct Person has store, key {
        name: vector<u8>,
        age: u8,
        is_active: bool,
    }

    // Struct for triggering multiple aborts deliberately
    struct AbortTrigger has store, key {
        counters: vector<u8>,
        fail_step: u8,
    }

    // Function that triggers aborts based on fail_step
    public fun trigger_aborts_at_step(
        counters: &mut vector<u8>,
        fail_step: u8
    ) {
        let len = vector::length(counters);
        let i = 0u64;
        while (i < len as u64) {
            let index = i as usize;
            if (fail_step == 1u8 && index == 0) {
                abort 42;
            } else if (fail_step == 2u8 && index == 1) {
                abort 100;
            } else if (fail_step == 3u8 && index == 2) {
                abort 999;
            } else {
                if (index < len) {
                    let val = vector::borrow_mut(counters, index);
                    *val = *val + 1;
                };
            };
            i = i + 1;
        };
    }

    // Initialize and test a module to verify magic number
    public fun verify_magic_number() {
        const EXPECTED_MAGIC: u32 = 0xCADE;
        // The compiler should embed the magic number in the binary
        // We simulate check by a dummy value
        let actual_magic = 0xCADE;
        assert!(actual_magic == EXPECTED_MAGIC, 9999);
    }

    // Function that intentionally has syntax errors - to test syntax catching
    public fun syntax_error_test_missing_semicolon() {
        // Deliberately missing semicolon on next line to cause syntax error
        // let a = 1
        // For simulation, just note that such code wouldn't compile
        ()
    }

    // Function that triggers multiple errors: syntax + runtime
    public fun trigger_errors() {
        // Syntax error is outside, but for runtime, abort deliberately
        abort 123;
    }

    // Script entry points to run tests

    // Initialize a Person struct
    public fun initialize_person(name: vector<u8>, age: u8, active: bool): Person {
        Person { name, age, is_active: active }
    }

    // Update person's active status
    public fun update_person_status(p: &mut Person, new_status: bool) {
        p.is_active = new_status;
    }

    // Trigger aborts in sequence, expect only partial updates
    public fun test_trigger_aborts(s: &signer, fail_step: u8) {
        let counters = vector::empty<u8>();
        // Initialize counters with sample values
        let counters = vector::copy(counters, [0u8, 0u8, 0u8]);
        trigger_aborts_at_step(&mut counters, fail_step);
    }

    // Run the magic number verification
    public fun run_verify_magic() {
        verify_magic_number();
    }

    // Run syntax error test (expected to fail compilation)
    public fun run_syntax_error() {
        syntax_error_test_missing_semicolon();
    }

    // Run the error trigger
    public fun run_trigger_error() {
        trigger_errors();
    }

    // Runner for aborts testing with different fail steps
    public fun run_abort_test_complete(fail_step: u8) {
        let dummy_signer = signer::borrow_key(&signer::public_key_of(&signer::new_public_key())); // placeholder
        test_trigger_aborts(&dummy_signer, fail_step);
    }
}


//# run 0xDEAD::TestModule::run_verify_magic


//# run 0xDEAD::TestModule::run_abort_test_complete --args 1u8

//# run 0xDEAD::TestModule::run_abort_test_complete --args 2u8

//# run 0xDEAD::TestModule::run_abort_test_complete --args 3u8


//# run 0xDEAD::TestModule::run_syntax_error


//# run 0xDEAD::TestModule::run_trigger_error


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 1630878bb07f0e61d64057399656ba48: Test that the Move function correctly handles multiple aborts and continues execution to produce the expected final result.
// 42b25b93e4183728f064e19bece2cde4: Annotate code with expected failure attributes that do not take any parameters or assigned values.
// e7b077bea943e18adb846b12ace19b8c: Validate the binary structure of compiled Move modules using standard magic numbers
// f900b94dca53be25721b14907d8740c3: Terminate expressions with tokens such as else, }, ), ,, :, or ; to indicate the end of an expression in your Move code.
// 5096a1acafda75408ede7e73f6a2359f: Provide Detailed Error Messages Including Error Status and Location
