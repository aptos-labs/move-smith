
//# publish
module 0xCAFE::PragmaAndPatterns {
    use std::signer;
    use std::vector;

    /// We define a constant that mimics a pragma property with a name.
    /// Although Move does not support pragma directives as such,
    /// we simulate a named pragma with a constant for the transactional test.
    const PRAGMA_PROPERTY_NAME: &vector<u8> = b"example_pragma_name";

    /// A struct to be used with pattern binding demonstration.
    struct Point has copy, drop, store {
        x: u8,
        y: u8,
    }

    /// Function demonstrating binding a pattern to a value with associated source range metadata.
    /// This is a simulated scenario: source ranges are not part of Move syntax,
    /// but we can demonstrate a tuple holding a value and a range.
    struct SourceRange has copy, drop {
        start: u16,
        end: u16,
    }

    struct PatternBound<T> has copy, drop {
        value: T,
        source_range: SourceRange,
    }

    public fun bind_pattern(): PatternBound<Point> {
        let p = Point { x: 10u8, y: 20u8 };

        // Simulating source range assignment with some arbitrary range.
        let range = SourceRange { start: 5u16, end: 15u16 };
        let pattern_bound = PatternBound<Point> { value: p, source_range: range };

        pattern_bound
    }

    /// Module that "manages" script specifications by processing a vector of them.
    /// Here, a ScriptSpec is represented as a struct with name and an enabled flag.
    struct ScriptSpec has copy, drop {
        name: vector<u8>,
        enabled: bool,
    }

    /// Filters a vector of ScriptSpec to only retain enabled scripts,
    /// and returns a vector of their names.
    public fun filter_enabled_scripts(scripts: vector<ScriptSpec>): vector<vector<u8>> {
        let enabled_scripts = vector::empty<vector<u8>>();
        let len = vector::length(&scripts);
        let i = 0;
        while (i < len) {
            let script = vector::borrow(&scripts, i);
            if (script.enabled) {
                vector::push_back(&mut enabled_scripts, copy *script.name);
            };
            i = i + 1;
        };
        enabled_scripts
    }

    /// A runner function for the filter with hardcoded inputs.
    public fun run_filter() {
        let spec1 = ScriptSpec { name: b"spec_one", enabled: true };
        let spec2 = ScriptSpec { name: b"spec_two", enabled: false };
        let spec3 = ScriptSpec { name: b"spec_three", enabled: true };
        let specs = vector::empty<ScriptSpec>();
        vector::push_back(&mut specs, spec1);
        vector::push_back(&mut specs, spec2);
        vector::push_back(&mut specs, spec3);

        let enabled = filter_enabled_scripts(specs);

        // No assert required, but we use variable to avoid warnings
        let _ = enabled;
    }
}



//# run 0xCAFE::PragmaAndPatterns::bind_pattern



//# run 0xCAFE::PragmaAndPatterns::run_filter


// Featurres:
// 9ec4d4b8700d08b8c9f4fe7c1c402dc8: Declare pragma properties with a name in Move code.
// 506f045b6a788390d0f2f114626c1774: Bind patterns to values with associated source code ranges in a single statement
// 9d772f2dfc9e51f96f4a68dcceb3c7e7: Manage script specifications by filtering and transforming them as needed.
