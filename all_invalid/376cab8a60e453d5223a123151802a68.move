
//# publish
module 0xCAFE::SpecModule {
    use std::vector;

    // Specification module with no functionality, only types/definitions
    struct SpecData has store, key {
        value: u64,
        flag: bool,
    }

    public fun dummy_spec() {}
}



//# publish
module 0xCAFE::ImplementationModule {
    use std::vector;
    use 0xCAFE::SpecModule;

    // Implementation module; will be merge tested with the spec module
    struct ImplData has store, key {
        value: u64,
        factor: u32,
    }

    public fun create_impl_data(v: u64, f: u32): ImplData {
        ImplData {value: v, factor: f}
    }

    public fun assign_and_multiply(s: &mut ImplData, input: u64, condition: bool): u64 {
        if (condition) {
            s.value = input + 10;
        } else {
            s.value = input * 2;
        }; // Added semicolon here
        bar(s.value, s.factor)
    }

    fun bar(val: u64, factor: u32): u64 {
        // Simple multiply
        val * (factor as u64)
    }

    // Function invoker to test the combined behavior
    public fun test_merge_and_invoke(): u64 {
        let impl = create_impl_data(5, 3);
        let result = assign_and_multiply(&mut impl, 7, true);
        result
    }
}



//# run 0xCAFE::ImplementationModule::test_merge_and_invoke



//# publish
module 0xCAFE::ModifierModule {
    use std::vector;

    // Function that uses 'use' for module import syntax, with a main that calls another function
    public fun run_with_modifiers(): u64 {
        helper_function()
    }

    fun helper_function(): u64 {
        // returns a constant
        42
    }
}



//# run 0xCAFE::ModifierModule::run_with_modifiers