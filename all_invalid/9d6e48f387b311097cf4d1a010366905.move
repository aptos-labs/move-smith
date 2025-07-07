
//# publish
module 0xCAFE::EntryAndFuncTypes {
    use std::signer;

    // Struct to store call counts under accounts
    struct CallCount has store, key {
        count: u64
    }

    // A public entry function that can only be called via transaction
    entry fun increment_count(account: signer) {
        let addr = signer::address_of(&account);
        if (!exists<CallCount>(addr)) {
            move_to<CallCount>(&account, CallCount { count: 1 });
        } else {
            let cc_ref = borrow_global_mut<CallCount>(addr);
            cc_ref.count = cc_ref.count + 1;
        };
    }

    // A function type with ability constraints
    public fun run_fn_u8_u8(f: |u8|u8, input: u8): u8 {
        f(input)
    }

    // A function type returning bool (copy + drop)
    public fun run_fn_bool_bool(f: |bool|bool, input: bool): bool {
        f(input)
    }

    // Entry function accepting a function type and invoking it
    // (Simulating passing a function as argument to an entry)
    entry fun call_fn_type(account: signer, f: |u8|u8, val: u8): u8 {
        run_fn_u8_u8(f, val)
    }

    // Runner with no arguments for tests
    public fun runner_no_arg() {
        let _res1 = run_fn_u8_u8(|x: u8| { x + 10u8 }, 5u8);
        let _res2 = run_fn_bool_bool(|b: bool| { !b }, true);
        // Just discard results; no assertion needed
    }

    // Entry accepting a function type returning bool and calls it
    entry fun call_bool_fn(account: signer, f: |bool|bool, b: bool): bool {
        run_fn_bool_bool(f, b)
    }
}

//# run 0xCAFE::EntryAndFuncTypes::increment_count --signers 0xBEEF


//# run 0xCAFE::EntryAndFuncTypes::increment_count --signers 0xBEEF


//# run 0xCAFE::EntryAndFuncTypes::runner_no_arg


//# run 0xCAFE::EntryAndFuncTypes::call_fn_type --signers 0xFEED --args 0xCAFE::EntryAndFuncTypes::run_fn_u8_u8 20u8


//# run 0xCAFE::EntryAndFuncTypes::call_bool_fn --signers 0xDEAD --args 0xCAFE::EntryAndFuncTypes::run_fn_bool_bool false

//--------------------------------------------
// The following module simulates different logging environment variable scenarios
// by defining distinct modules with varied visibility or dummy methods emitting logs
// (This is a simulation because logging env vars affect compilation/execution external to Move code)
//--------------------------------------------


//# publish
module 0xCAFE::LoggingSimulator {
    // Fake function to simulate different logging verbosity outputs in Move
    // (In real Aptos VM env, logging controlled by env vars in node setup, not Move code)
    public fun log_level_0() {
        // No op, simulating "no logs"
    }

    public fun log_level_1() {
        // Simulate a warning log by writing to an event store or a dummy operation
    }

    public fun log_level_2() {
        // Simulate info-level logs
    }

    public fun log_level_3() {
        // Simulate debug-level logs
    }

    // Public runner calling all above to simulate combined effects
    public fun all_levels() {
        log_level_0();
        log_level_1();
        log_level_2();
        log_level_3();
    }
}

//# run 0xCAFE::LoggingSimulator::all_levels

//--------------------------------------------
// Combined scenario: Entry function accepting function type and triggering 'logs'
//--------------------------------------------


//# publish
module 0xCAFE::CombinedFeatures {
    use std::signer;
    use 0xCAFE::LoggingSimulator;

    // Entry function takes a function type and bool input
    entry fun run_and_log(account: signer, f: |bool|bool, val: bool): bool {
        // Invoke logging simulation
        LoggingSimulator::log_level_2();
        f(val)
    }

    public fun run_passed_func(f: |u8|u8, val: u8): u8 {
        f(val)
    }

    // Runner with internal lambda to run and call entry function
    public fun runner() {
        let increment = |x: u8| x + 1u8;
        let _r = run_passed_func(increment, 33u8);
    }
}

//# run 0xCAFE::CombinedFeatures::runner


//# run 0xCAFE::CombinedFeatures::run_and_log --signers 0xBEEF --args 0xCAFE::EntryAndFuncTypes::run_fn_bool_bool true


// Featurres:
// 1d3f5417b818a4ff0c73905c1617597a: Use the 'entry' modifier on module members to indicate entry functions.
// 96548523ba272d475e58815244cacbcb: Define and use function types (lambda-like types) that specify argument types, return type, and ability constraints.
// bd1017e17faf5ea5b8da39f82b2b1350: Control logging output of the Move compiler by setting an environment variable to specify logging verbosity and output file.
