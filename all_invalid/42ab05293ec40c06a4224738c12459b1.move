
//# publish
module 0xCAFE::test_module {
    // Define a struct with various abilities
    struct TestAbilities has copy, drop, store, key {
        value: u64,
    }

    // Function to create an instance of TestAbilities
    public fun create_instance(): TestAbilities {
        TestAbilities { value: 42 }
    }
}

 
//# run 0xCAFE::test_module::create_instance
// Define a function that tests variable initialization in both branches of an if-else statement
module 0xCAFE::conditional_test {
    use 0xCAFE::test_module::TestAbilities;

    // Function that initializes a variable in both branches and uses it after
    public fun test_conditional_flag(flag: bool): u64 {
        let x: u64;
        if (flag) {
            x = 10;
        } else {
            x = 20;
        };
        // Use the variable after the conditional
        x
    }

    // Function to test declaring type abilities (copy, drop, store, key)
    public fun declare_struct_with_abilities(): TestAbilities {
        // Create an instance; abilities are declared in the struct
        TestAbilities { value: 123 }
    }

    // Function to test parameter list syntax for spec functions
    public fun spec_function(param1: u8, param2: u64): bool {
        param1 > 0 && param2 > 0
    }

    // Runner function that calls previous functions
    public fun run_all(flag: bool): (u64, TestAbilities, bool) {
        let init = create_instance();
        let cond_result = test_conditional_flag(flag);
        let abilities_instance = declare_struct_with_abilities();
        let spec_result = spec_function(1, 100);
        (cond_result, abilities_instance, spec_result)
    }
}

 
//# run 0xCAFE::conditional_test::run_all --args true --signers 0xCAFE

// Featurres:
// 3cfd637587f89cbe0679fe4f37d64568: Test that variables initialized within both branches of an if-else statement are properly recognized and can be used after the conditional.
// 04a0c8595d70719671ccf6bc64624606: Declare type abilities (such as 'copy', 'drop', 'store', or 'key') using the 'has' keyword on structs
// 2e4ebf04c2d86df71fbc6d8bdd0249a8: Declare parameter lists for spec functions using standard Move syntax.
