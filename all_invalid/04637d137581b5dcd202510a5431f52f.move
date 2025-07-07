
//# publish
module 0xBEEF::InteractionTest {
    use std::signer;

    // Define a resource with internal access functions
    struct InternalData {
        counter: u64,
        flag: bool,
    }

    // Public entry point to initialize resource under a signer
    public fun initialize(s: signer) {
        move_to<InternalData>(&s, InternalData { counter: 0, flag: false });
    }

    // Internal function to increment counter, only accessible within this module
    fun increment_counter(data: &mut InternalData) {
        data.counter = data.counter + 1;
    }

    // Function to read the counter, not public
    fun get_counter(s: &signer): u64 {
        let data_ref: &InternalData = borrow_global<InternalData>(signer::address_of(s));
        data_ref.counter
    }

    // Script to initialize, manipulate, and test internal access
    public fun entry_point(s: signer) {
        let data_ref: &mut InternalData = borrow_global_mut<InternalData>(signer::address_of(&s));
        // Use internal function within the module
        increment_counter(&mut data_ref);
        // Read the value
        let _counter_value = data_ref.counter;
    }

    // Public function to test access restrictions from outside
    public fun external_access(s: signer) {
        let data_ref: &mut InternalData = borrow_global_mut<InternalData>(signer::address_of(&s));
        increment_counter(&mut data_ref);
    }

    // Function with variable shadowing across while loop
    public fun variable_shadowing_test(_: signer): u64 {
        let x: u64 = 10;
        let y: u64 = 0;

        if (x > 5) {
            y = x * 2;
        };

        // Shadow variable `x` inside the loop
        while (x > 0) {
            let x: u64 = x - 1; // shadowed
            y = y + x;
        };

        y
    }

    // Function with local variables outside and inside 'while'
    public fun control_flow_variables(_: signer): u64 {
        let sum: u64 = 0;
        let count: u64 = 0;

        let limit: u64 = 5;

        while (count < limit) {
            let temp: u64 = count * 2; // local within loop
            sum = sum + temp;
            count = count + 1;
        };

        sum
    }

    // Testing module referencing with number and named address
    public fun external_module_reference() {
        // It should resolve correctly whether address is number or named
        let _ = 0xCAFE::MyModule::f1(1u8, true);
        let _ = 0xBEEF::InteractionTest::variable_shadowing_test();
    }

    // Spec module with marked functions (simulating annotations)
    
//# use 0xCAFE::Spec
    public fun spec_function() {
        // Intentional placeholder: Suppose we call a spec function
        // Placeholder for spec interaction
    }

    // Use module
    
//# use 0xDEADBEEF::Use
    public fun use_function() {
        // Placeholder for Use interactions
    }

    // Internal functions should not be accessible from outside
    fun internal_only() {
        // Should not be callable externally
    }

    // Public runner function to test all internal/external aspect
    public fun run_all() {
        // Initialize resource with a signer
        // (simulate calling initialize with a signer, in test harness)
        // For demonstration, code is conceptual
        // This function can be called via script
    }
}


//# run 0xBEEF::InteractionTest::entry_point --signers 0xDA00

//# run 0xBEEF::InteractionTest::external_access --signers 0xDA00

//# run 0xBEEF::InteractionTest::control_flow_variables --signers 0xDA00

//# run 0xBEEF::InteractionTest::variable_shadowing_test --signers 0xDA00

//# run 0xBEEF::InteractionTest::external_module_reference --signers 0xDA00

//# run 0xBEEF::InteractionTest::run_all --signers 0xDA00

// Additional test scripts to run internal functions with various control flow and module references


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// e6f30b85424e139c306d6bec24378617: Refer to Move modules either by their named address or by their numerical (hex) address in module identifiers.
// b2cc35d56ab7f2b6f53c0e9c0ea3e065: Include only modules with specification annotations such as 'Spec' or 'Use' in the source code.
// b47c54045accd6dc8b836826a0ccd293: Display diagnostics and error messages produced by the Move compiler in a structured buffer format for further inspection or use.
