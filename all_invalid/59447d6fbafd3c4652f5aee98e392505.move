// Corrected module with proper syntax for native functions and attributes
//# publish
module 0xBADD::NativeFeatures {
    use std::string;

    // Mark functions as native with the attribute // native]
    // native]
    public fun external_func1(): u64;

    // native]
    public fun external_func2(x: u64): bool;

    // Use // deprecated] attribute for deprecated functions
    // deprecated]
    public fun deprecated_func(): bool {
        false
    }

    // deprecated]
    public fun deprecated_with_args(x: u8): u8 {
        x
    }

    public fun test_mark_native() {
        let _result1 = external_func1();
        let _result2 = external_func2(42);

        // Use deprecated functions
        let _deprecated_result = deprecated_func();
        let _deprecated_with_args = deprecated_with_args(7u8);
    }

    public fun generate_event_string(events: vector<string>): string {
        let result = string::empty();

        let length = vector::length(&events);
        let index = 0;
        while (index < length) {
            let event_str_ref = vector::borrow(&events, index);
            let event_str = *event_str_ref;
            // Append event string to result
            result = string::append(&result, &event_str);
            if (index + 1 < length) {
                result = string::append(&result, &b", "[u8]);
            }
            index = index + 1;
        };
        result
    }

    // Helper: convert a vector of string slices into a vector of strings for testing
    public fun run_event_string_generation() {
        let event1 = string::from_bytes(b"Start");
        let event2 = string::from_bytes(b"Processing");
        let event3 = string::from_bytes(b"Finished");
        let events = vector::empty<string>();
        vector::push_back(&mut events, event1);
        vector::push_back(&mut events, event2);
        vector::push_back(&mut events, event3);
        let result = generate_event_string(events);
    }

    // Test generating string representation of events
    public fun test_event_string() {
        run_event_string_generation();
    }
}


//# run 0xBADD::NativeFeatures::test_mark_native --signers 0xCAFE

//# run 0xBADD::NativeFeatures::test_event_string --signers 0xCAFE
