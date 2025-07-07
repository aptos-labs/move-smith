
//# publish
module 0xBADD::NativeFeatures {
    use std::string;

    // native]
    public fun external_func1(): u64;

    // native]
    public fun external_func2(x: u64): bool;

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
            };
            index = index + 1;
        };
        result
    }

    // Helper: convert a vector of string slices into a vector of strings for testing
    public fun run_event_string_generation() {
        let event1 = string::from(b"Start");
        let event2 = string::from(b"Processing");
        let event3 = string::from(b"Finished");
        let events = vector::empty<string>();
        vector::push_back(&mut (events), event1);
        vector::push_back(&mut (events), event2);
        vector::push_back(&mut (events), event3);
        let result = generate_event_string(events);
    }

    // Test generating string representation of events
    public fun test_event_string() {
        run_event_string_generation();
    }
}


//# run 0xBADD::NativeFeatures::test_mark_native --signers 0xCAFE


//# run 0xBADD::NativeFeatures::test_event_string --signers 0xCAFE


// Featurres:
// 23028a622093b2d13fc6c7bf2bb93f16: Mark functions as native to indicate they are implemented outside Move language.
// 48f0c00531ce65d078a7d96bd137d93e: Check if specific attributes, such as `#[deprecated]`, are present to inform users or tools of deprecation status.
// 4c58d7885ded84952dba85ff5adf684b: Generate a string representation of live interval events for debugging or analysis
