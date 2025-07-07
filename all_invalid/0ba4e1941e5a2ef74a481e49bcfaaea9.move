//# publish
module 0x1::TestModuleSpecUse {
    // Include only modules with 'Spec' or 'Use' annotations - simulated here with a comment
    // Note: Spec and Use annotations are typically comments used for specification, no code needed

    //////////////////////////////////////////////////////////
    // 2: Declare a struct with optional visibility modifiers
    // Enforce that visibility modifiers are only allowed in language v2.
    // (Assuming language v2 is enabled, else visibility modifiers are ignored)
    //////////////////////////////////////////////////////////

    // Assuming feature flag for language v2 is enabled, so use 'public' visibility
    public struct VisibilityTest {
        value: u64,
    }

    //////////////////////////////////////////////////////////
    // 3: Configure error reporting to output errors to a specified writer
    //////////////////////////////////////////////////////////

    // Simulated configuration function to set error writer
    public fun configure_error_writer(writer: &mut dyn std::io::Write) {
        // In actual implementation, we would configure compiler error output target.
        // Here, just a placeholder to simulate configuration.
        // No runtime action needed for test.
        move()
    }

    //////////////////////////////////////////////////////////
    // 4: Define specification functions with names prefixed by '$'
    //////////////////////////////////////////////////////////

    // A spec function for verifying some property
    public fun $verify_invariant(x: &VisibilityTest): bool {
        // Dummy invariant: value must be > 0
        x.value > 0
    }

    // Another spec function
    public fun $check_state(): bool {
        // Dummy general state check
        true
    }

    //////////////////////////////////////////////////////////
    // 5: Allow defining behaviors for list parsing with closures
    //////////////////////////////////////////////////////////

    // Simulate list parsing with continue and terminate functions

    // Function type for continuation
    fun type ListParseContinue<T> = (list: &vector<T>) -> bool;

    // Function type for termination condition
    fun type ListParseTerminate<T> = (list: &vector<T>) -> bool;

    // Example parsing function
    public fun parse_list<T>(
        list: &vector<T>,
        continue_fn: &fun() -> bool,
        terminate_fn: &fun() -> bool
    ): vector<T> {
        let mut parsed: vector<T> = vector::empty<T>();
        let size = vector::length<T>(list);
        let mut index = 0;
        while (index < size) {
            // Simulate parse element
            if (continue_fn()) {
                vector::push_back(&mut parsed, vector::borrow<T>(list, index));
                index = index + 1;
            } else if (terminate_fn()) {
                break;
            } else {
                // Continue parsing
                index = index + 1;
            }
        }
        parsed
    }

    // Runner functions to pass as closures
    public fun continue_parse(): bool {
        true // continue parsing
    }

    public fun terminate_parse(): bool {
        false // never terminate early
    }

    //////////////////////////////////////////////////////////
    // 6: Generate string representation of live interval events
    //////////////////////////////////////////////////////////

    // Dummy implementation for workflow event debug info
    public fun get_live_interval_events(): vector<string> {
        let events: vector<string> = vector::empty<string>();
        // Add dummy intervals
        vector::push_back(&mut events, "IntervalEvent1".to_string());
        vector::push_back(&mut events, "IntervalEvent2".to_string());
        events
    }
}

// //# run 0x1::TestModuleSpecUse::runner
module 0x1::TestRunner {
    use 0x1::TestModuleSpecUse;

    // Runner function to exercise all features
    public fun run() {
        // 2: Instantiate struct and verify visibility (simulate)
        let v_test = &mut 0x1::TestModuleSpecUse::VisibilityTest { value: 10 };

        // 3: Configure error reporting (simulate)
        // Note: Passing a dummy writer; in actual test, we'd pass a real writer
        // Here, we just call the function
        //'simulate' passing a writer
        // create dummy writer (not Mockito)
        let dummy_writer: &mut dyn std::io::Write = &mut { /* dummy */ };
        0x1::TestModuleSpecUse::configure_error_writer(dummy_writer);

        // 4: Call spec functions with $ prefix
        let invariant = 0x1::TestModuleSpecUse::$verify_invariant(v_test);
        let state_ok = 0x1::TestModuleSpecUse::$check_state();

        // 5: Test list parsing with continue and terminate functions
        let list: vector<u8> = vector::from( [1, 2, 3, 4, 5] );
        let parsed_list = 0x1::TestModuleSpecUse::parse_list(
            &list,
            &0x1::TestModuleSpecUse::continue_parse,
            &0x1::TestModuleSpecUse::terminate_parse
        );

        // 6: Generate string of live interval events
        let events = 0x1::TestModuleSpecUse::get_live_interval_events();

        // (No assertions, just execute)
        move()
    }
}

// //# run 0x1::TestRunner::run --signers 0xABCDEF