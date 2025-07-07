
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



//# publish
module 0xCAFE::conditional_test {
    use 0xCAFE::test_module::TestAbilities;

    // Function that initializes a variable in both branches and uses it after
    public fun test_conditional_flag(flag: bool): u64 {
        let x = if (flag) {
            10
        } else {
            20
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