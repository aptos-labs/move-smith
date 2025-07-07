
//# publish
module 0xDEAD::TestModule {
    use std::vector;
    use std::string;
    use std::signer;

    // Define a private/internal function
    fun internal_helper(x: u64): u64 {
        x + 10
    }

    // Public function to test internal access (accessible only within the module)
    public fun call_internal_helper(x: u64): u64 {
        internal_helper(x)
    }

    // Entry function callable from scripts, interacts with module state
    public fun script_entry(x: u64): u64 {
        internal_helper(x)
    }

    // Function that intentionally aborts with a specific code
    public fun fail_function(): {
        abort 999;
    }

    // Internal function with internal visibility
    fun internal_internal_func(): u8 {
        42
    }

    // Variable shadowing example
    public fun shadowing_example() {
        let x: u8 = 1;
        let x: u8 = x + 1; // shadow outer x
        // the outer x is shadowed; this inner x is 2
        // here, scope exit is implicit at end of function
        x // returns 2
    }

    // Function with sequence expression (omit last expression to check auto-append unit)
    public fun sequence_expression_test(): () {
        let seq = sequence {
            1u8;
            2u8
        }; // Missing semicolon after 2u8, compiler should cleanup and add unit
        ()
    }
}



//# run 0xDEAD::TestModule::script_entry --args 55u64



//# run 0xDEAD::TestModule::call_internal_helper --args 123u64



//# run 0xDEAD::TestModule::shadowing_example



//# run 0xDEAD::TestModule::sequence_expression_test



//# run 0xDEAD::TestModule::fail_function -- --abort 999




//# publish
module 0xDEAD::InternalOnly {
    use std::signer;

    // internal function with internal visibility
    fun internal_func(): u8 {
        255
    }

    // Public function attempting to call internal function (allowed within same module)
    public fun call_internal_func(): u8 {
        internal_func()
    }
}

// No script directly calling internal_func from outside as it's internal,
// but verify that calling via public wrapper is allowed.



//# run 0xDEAD::InternalOnly::call_internal_func



//# publish
module 0xDEAD::ScopeTest {
    use std::vector;
    use std::string;

    // Check loops and variable scope
    public fun while_loop_test(): u8 {
        let outer_counter = 0u8;

        // simulate while with a for loop or recursion is complex;
        // here, just demonstrate variable scope and shadowing
        let _ = nested_block(outer_counter);
        outer_counter
    }

    fun nested_block(x: u8): u8 {
        let inner_x = x + 1;
        inner_x
    }
}



//# run 0xDEAD::ScopeTest::while_loop_test



//# publish
module 0xDEAD::ScopeTestReusable {
    use std::vector;
    use std::string;

    // Demonstrate shadowing and local variable reassignment inside loops
    public fun shadow_in_loop(): u64 {
        let x: u64 = 10;
        let total: u64 = 0;

        for (i in 0..3) {
            let x = x + i; // shadow outer x
            total = total + x;
        }
        total
    }
}



//# run 0xDEAD::ScopeTestReusable::shadow_in_loop



//# publish
module 0xDEAD::AbortTest {
    // Use this module to verify that aborts with specific codes are captured properly.

    // Function expected to abort; used to test failure recognition.
    public fun abort_test(): {
        abort 1234;
    }

    // Function that calls abort_test
    public fun wrapper(): {
        abort_test()
    }
}



//# run 0xDEAD::AbortTest::wrapper -- --abort 1234
