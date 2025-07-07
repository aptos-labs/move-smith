
//# publish
module 0xCAFE::AbilityConstrainedModule {
    // Test generic type parameters with ability constraints using ':'

    struct HasKeyAndCopy has key, copy, drop {
        value: u64,
    }

    struct HasCopyOnly has copy, drop {
        val: u8,
    }

    // Generic struct with constraint for has copy
    struct CopyHolder<T: copy> has copy, drop {
        inner: T,
    }

    // Generic struct with constraint for has key and copy
    struct KeyCopyHolder<T: key + copy> has key, copy, drop {
        inner: T,
    }

    // Function accepting T with copy ability only
    public fun accept_copy<T: copy>(val: T): CopyHolder<T> {
        CopyHolder<T> { inner: val }
    }

    // Function accepting T with key + copy abilities
    public fun accept_key_copy<T: key + copy>(val: T): KeyCopyHolder<T> {
        KeyCopyHolder<T> { inner: val }
    }

    // Runner function to be called without args to test above
    public fun runner() {
        let a = HasCopyOnly { val: 7 };
        let _c_holder = accept_copy<HasCopyOnly>(a);

        let b = HasKeyAndCopy { value: 42 };
        let _kc_holder = accept_key_copy<HasKeyAndCopy>(b);
    }
}



//# run 0xCAFE::AbilityConstrainedModule::runner




//# publish
module 0xCAFE::LintAttributesModule {
    use std::debug;

    // lint_skip(mutation)]
    // Module-level lint skip attribute to suppress "mutation" lint inside this module

    struct Data has copy, drop, store {
        counter: u64,
    }

    public fun mutate_counter(data: &mut Data) {
        // This mutation should be allowed due to lint_skip at module-level
        data.counter = data.counter + 1;
    }

    // lint_skip(mut_var)]
    // Override lint skip inside function to also skip mutable var lint 

    public fun mutate_with_local_mut() {
        let local_var = 10; // mut var allowed due to lint_skip(mut_var)
        local_var = local_var + 5;
        debug::print(&local_var);
    }

    public fun normal_function() {
        // No local mut var here, no lint_skip override here
        let x = 1;
        let y = 2;
        let _z = x + y;
    }
}



//# run 0xCAFE::LintAttributesModule::mutate_with_local_mut



//# run 0xCAFE::LintAttributesModule::normal_function




//# publish
module 0xCAFE::ImportAliasModule {
    use 0xCAFE::AbilityConstrainedModule;

    // Create a local alias for struct HasCopyOnly
    use 0xCAFE::AbilityConstrainedModule::HasCopyOnly as HCO;

    // Create another alias for the generic struct CopyHolder
    use 0xCAFE::AbilityConstrainedModule::CopyHolder as CHolder;

    // Function to test usage of aliased names with generic constraints
    public fun alias_generic_test() {
        let val = HCO { val: 99 };
        let _holder = CHolder<HCO> { inner: val };
    }
    
    // Nested function testing generic function call across aliases
    public fun call_accept_copy() {
        let val = HCO { val: 123 };
        let _c = AbilityConstrainedModule::accept_copy<HCO>(val);
    }
}



//# run 0xCAFE::ImportAliasModule::alias_generic_test



//# run 0xCAFE::ImportAliasModule::call_accept_copy




//# publish
module 0xCAFE::CombinedTest {
    use 0xCAFE::AbilityConstrainedModule;
    use 0xCAFE::LintAttributesModule;
    use 0xCAFE::ImportAliasModule;

    // lint_skip(mutation)]
    // Module-level lint skip attribute to suppress "mutation" lint inside this module

    // Generic function with ability constraints and lint attribute inheritance
    public fun combined_function<T: copy + drop>(val: T) {
        // Create a local variable and mutate
        let local_counter = 0;
        local_counter = local_counter + 1;

        // Call function from alias module that uses generic constraint
        ImportAliasModule::alias_generic_test();

        // Call function from lint attribute module that has mutation lint skipped
        let data = LintAttributesModule::Data { counter: 0 };
        LintAttributesModule::mutate_counter(&mut data);

        // Use generic function with ability constraint from AbilityConstrainedModule
        let _holder = AbilityConstrainedModule::accept_copy<T>(val);
    }

    public fun combined_runner() {
        let value = AbilityConstrainedModule::HasCopyOnly { val: 11 };
        combined_function<AbilityConstrainedModule::HasCopyOnly>(value);
    }
}



//# run 0xCAFE::CombinedTest::combined_runner


// Features:
// bb436b770613359bad6161693f13d82f: Declare ability constraints on types using the ':' syntax in type parameters
// f9718d4b5c8c4f8215b2c2199223908e: Inherit module-wide lint skip settings in functions to suppress additional lints based on module attributes.
// 52af0a15bfa3dc43c7ec2b925fadf5fb: Create local aliases for imported modules or identifiers via the 'use' syntax
