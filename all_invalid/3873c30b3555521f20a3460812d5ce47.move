// #publish
module 0xCAFE::ModuleVisibilityAccessSpec {
    use std::vector;

    struct S has copy, drop, store, key {
        x: u64,
    }

    // public with full qualified names as visibility modifier for functions
    public fun public_function(): u64 {
        10
    }

    // `friend` visibility with fully qualified module name
    friend 0xCAFE::ModuleVisibilityAccessSpec fun friend_function(): u64 {
        20
    }

    // private function, can only be called inside this module
    fun private_function(): u64 {
        30
    }

    // public inline function with friend visibility
    friend 0xCAFE::ModuleVisibilityAccessSpec public inline fun friend_public_inline(): u64 {
        40
    }

    // Function to call all visibility variants internally
    public fun run_all_visibility_calls(): (u64, u64, u64, u64) {
        (Self::public_function(), Self::friend_function(), Self::private_function(), Self::friend_public_inline())
    }

    // or an example of a resource in storage with spec
    spec module {
        // global variable spec
        global module global_var: u64;
        // local variable spec (dummy example)
        local local_var_greater_than_zero: bool;
    }
}
// #run 0xCAFE::ModuleVisibilityAccessSpec::run_all_visibility_calls


// #publish
module 0xCAFE::ModuleLoopContinueSpec {
    // This module tests usage of loop and continue statements

    public fun loop_continue_example(): u64 {
        let mut sum = 0u64;
        let mut i = 0u64;
        while (i < 10) {
            i = i + 1;
            if (i % 2 == 0) {
                continue; // skip even numbers
            };
            // odd numbers added
            sum = sum + i;
        };
        sum
    }

    // complex example: loop with continue in nested conditions and break
    public fun loop_continue_break_example(): u64 {
        let mut sum = 0u64;
        let mut i = 0u64;
        while (true) {
            i = i + 1;
            if (i > 20) {
                break;
            };
            if (i % 5 == 0) {
                continue; // skip multiples of 5
            };
            sum = sum + i;
        };
        sum
    }
}
// #run 0xCAFE::ModuleLoopContinueSpec::loop_continue_example
// #run 0xCAFE::ModuleLoopContinueSpec::loop_continue_break_example


// #publish
module 0xCAFE::ModuleSpecVars {
    /// This module is to test specification variables

    struct S has copy, drop, store, key {
        field: u64,
    }

    // Function that changes a global variable
    public global spec(global_var: u64);

    spec module {
        // Declare a global variable for the module
        global global_u64: u64;
    }

    public fun initialize_global(account: &signer) {
        move_to(account, S { field: 42 });
    }

    #[spec]
    public spec fun example_specification() {
        // specify global variable usage in specs
        global global_u64 >= 0;

        // specify local variable
        let local_spec_var: u64 = 10;
        local local_spec_var > 0;
    }

    // run function that moves resource to storage
    public fun run(account: &signer) {
        move_to(account, S { field: 100 });
    }
}
// #run 0xCAFE::ModuleSpecVars::run --signers 0xCAFE


// #run
script {
    use 0xCAFE::ModuleVisibilityAccessSpec;
    use 0xCAFE::ModuleLoopContinueSpec;
    use 0xCAFE::ModuleSpecVars;
    use std::signer;

    fun main(account: signer) {
        // Call ModuleVisibilityAccessSpec run_all_visibility_calls - returns a tuple of 4 u64s
        let (a, b, c, d) = ModuleVisibilityAccessSpec::run_all_visibility_calls();
        // We won't assert but can output in debug if it was supported

        // Call loop continue examples
        let sum1 = ModuleLoopContinueSpec::loop_continue_example();
        let sum2 = ModuleLoopContinueSpec::loop_continue_break_example();

        // Initialize storage resource for ModuleSpecVars
        ModuleSpecVars::run(&account);

        // Done
        return;
    }
}

// Featurres:
// 430e80f68e9e61c4854110039dc54f29: Use access specifiers that include qualified names as part of your visibility declarations.
// 9c17c0f79bb0cf1155bad21f26e45a5e: Use loop continue statements in expressions
// caa4ab8a3e36141117c8c50d0a12748d: Specify global or local variables in specifications.
