
//# publish
module 0xCAFE::TestModule {
    // Internal function to test internal visibility restrictions
    fun internal_func() {
        // dummy internal logic
    }

    // Public function to call internal_func to test proper internal access
    public fun call_internal_func() {
        internal_func();
    }

    // Function that has a variable shadowing scenario
    public fun shadowing_test(x: u8): u8 {
        let x = x + 1; // shadow outer x
        while (x < 5) {
            let x = x + 1; // inner shadowing, increment inner x
            if (x == 4) {
                break;
            };
        };
        // After the loop, return outer x + 1
        x
    }

    // Function that tests variable declaration outside and inside while loop
    public fun variable_scope_test() {
        let outer_var = 10;
        let _ = while_in_loop(&mut outer_var);
        outer_var
    }

    fun while_in_loop(outer_var: &mut u64): u64 {
        let i = 0; // declare mutable i
        while (i < 3) {
            let inner_var = i + 5; // local inner variable
            *outer_var = *outer_var + inner_var;
            i = i + 1;
        };
        // Return value not used, just for scope
        *outer_var
    }

    // Function that tries to invoke an internal function from outside - should be compile error if uncommented
    // public fun attempt_external_internal() {
    //     internal_func(); // Should be inaccessible outside the module
    // }

    // Function that verifies bytecode generation for a particular function
    public fun generate_bytecode_test() {
        // dummy function call to ensure bytecode is generated
        shadowing_test(2);
        variable_scope_test();
    }

    // Wrapper function to call generate_bytecode_test
    public fun run_bytecode_test() {
        generate_bytecode_test();
    }
}



//# run 0xCAFE::TestModule::call_internal_func --signers 0xBEEF


//# run 0xCAFE::TestModule::shadowing_test --args 2u8


//# run 0xCAFE::TestModule::variable_scope_test


//# run 0xCAFE::TestModule::generate_bytecode_test


//# run 0xCAFE::TestModule::run_bytecode_test
