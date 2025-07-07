//# publish
module 0xC0FFEE::EventUtils {
    use std::string;

    /// An enum representing live interval events.
    public enum LiveEvent {
        Start(u64),
        End(u64),
        Kill(u64, bool),
    }

    /// Convert a LiveEvent to a string for debugging or analysis.
    public fun event_to_string(event: &LiveEvent): string::String {
        match event {
            Self::LiveEvent::Start(x) => string::utf8(b"Start at ") + &string::u64(*x),
            Self::LiveEvent::End(x) => string::utf8(b"End at ") + &string::u64(*x),
            Self::LiveEvent::Kill(x, dead) => {
                let mut s = string::utf8(b"Kill at ");
                s = s + &string::u64(*x);
                s = s + &string::utf8(b", Dead=");
                s = s + &string::bool(*dead);
                s
            }
        }
    }
}

//# publish
module 0xCADE::TestMembers {
    // Test importing members (with and without aliasing), using module identifiers,
    // and generating event strings.
    use 0xC0FFEE::EventUtils::{LiveEvent, event_to_string as evt_str};

    /// Use explicit module identifier in type annotations.
    public fun module_id_usage(): 0xC0FFEE::EventUtils::LiveEvent {
        LiveEvent::Start(7)
    }

    /// Create a few events, convert them to strings.
    public fun runner() {
        let a = LiveEvent::Start(42);
        let b = LiveEvent::End(73);
        let c = LiveEvent::Kill(99, true);

        let s1 = evt_str(&a);
        let s2 = evt_str(&b);
        let s3 = evt_str(&c);
        // Strings are dropped for test, in a real setting might print or assert values
        // (Here exercise Move semantics, strings are dropped as locals)
    }
}

//# run 0xCADE::TestMembers::runner --signers 0xCADE

//# run
script {
    use members 0xC0FFEE::EventUtils::{LiveEvent, event_to_string};
    use 0xCADE::TestMembers;

    fun main() {
        let e = LiveEvent::Kill(315, false);
        let debug = event_to_string(&e);
        // Call the module_id_usage function for additional module identifier use.
        let _ = TestMembers::module_id_usage();
        // Drop debug string.
    }
}