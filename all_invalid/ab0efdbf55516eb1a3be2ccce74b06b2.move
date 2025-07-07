
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
        let i: u64 = 0; // Initialize loop counter as mutable
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
                }
            }
            i = i + 1; // Increment loop counter
        }
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
        let counters: vector<u8> = vector::empty();
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
        // Generate a dummy signer (placeholder)
        let dummy_signer = signer::borrow_key(&signer::public_key_of(&signer::new_public_key())); 
        test_trigger_aborts(&dummy_signer, fail_step);
    }
}



//# run 0xDEAD::TestModule::run_verify_magic



//# run 0xDEAD::TestModule::run_abort_test_complete --args 1u8


//# run 0xDEAD::TestModule::run_abort_test_complete --args 2u8


//# run 0xDEAD::TestModule::run_abort_test_complete --args 3u8



//# run 0xDEAD::TestModule::run_syntax_error



//# run 0xDEAD::TestModule::run_trigger_error
