
//# publish
module 0xBABE::CoreModule {
    use std::vector;

    // Core constant for testing
    const TEST_CONST: u64 = 123456789;

    // Struct for verification
    struct CoreData has store, key {
        value: u64,
        flag: bool,
    }

    public fun create_core_data(val: u64, flag: bool): CoreData {
        CoreData { value: val, flag }
    }

    public fun get_value(data: &CoreData): u64 {
        data.value
    }

    public fun set_value(data: &mut CoreData, new_val: u64) {
        data.value = new_val
    }

    public fun verify_const(): u64 {
        Self::TEST_CONST
    }
}


//# run 0xBABE::CoreModule::create_core_data --args 42u64 true


//# run 0xBABE::CoreModule::get_value --signers 0xCAFE --args 42u64 true


//# run 0xBABE::CoreModule::set_value --signers 0xCAFE --args 100u64 true


//# run 0xBABE::CoreModule::get_value --signers 0xCAFE --args 42u64 true


//# run 0xBABE::CoreModule::verify_const


//# publish
module 0xBABE::VariableCapture {
    use std::vector;

    // Outer variables to be captured in closures
    struct OuterVars has store {
        counter: u64,
    }

    public fun initialize_outer(signer: signer): OuterVars {
        OuterVars { counter: 0 }
    }

    // Function that mutates captured variable
    public fun increment_counter(vars: &mut OuterVars): u64 {
        vars.counter = vars.counter + 1;
        vars.counter
    }

    // Closure that shadows outer variable and mutates it
    public fun outer_closure(vars: &mut OuterVars): |u64| {
        |increment: u64| {
            // Shadowing outer 'counter' with inner variable
            let counter = vars.counter + increment;
            // Mutate the outer variable
            vars.counter = counter;
            vars.counter
        }
    }

    // Function to test capture and mutation through closure
    public fun test_capture_and_mutate(signer: signer): u64 {
        let vars = initialize_outer(signer);
        let outer_vars = &mut vars;

        // Create closure capturing outer_vars
        let closure = outer_closure(&mut outer_vars);

        // Call closure with 5
        let result1 = closure(5);
        // Call again with 3
        let result2 = closure(3);
        // Return final value of outer variable
        outer_vars.counter
    }
}


//# run 0xBABE::VariableCapture::test_capture_and_mutate --signers 0xBEEF

// The above tests verify:
    // - Modules compile into bytecode
    // - Scripts can invoke module functions correctly
    // - Variables are captured in closures and mutated correctly
    // - Shadowing works as expected within nested closures
    // - State mutations are reflected properly in outer scope


// Featurres:
// b5d81a20a5398c9d5b7dc51584b5ca34: Define modules in Move that will be verified for bytecode correctness after compilation.
// 301217b64f8dab9993b5bd4a43015d94: Use main functions in script modules to produce compiled scripts.
// 7ae320749aa1a3fa69ec63bdd6cf3ca6: Test that variables from the outer scope can be shadowed and mutated by closures passed to functions, verifying correct variable capture and assignment behavior.
