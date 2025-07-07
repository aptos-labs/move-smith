//# publish
module 0xCAFE::QuantifierTest {
    use std::vector;
    use std::math;

    struct Container has store {
        a: u8,
        b: u8,
        c: u8,
        d: u8,
    }

    /// Returns minimal u8 value where value > 5 and value < 10
    public fun choose_min_example(): u8 {
        // the prelude "choose min" quantifier is used here
        let min = choose min x: u8 such that (x > 5 && x < 10);
        min
    }

    public fun pattern_match_ignore_fields(c: Container): u8 {
        // Using '..' to ignore rest of the fields b, c, d of Container
        let Container {a, ..} = c;
        a
    }

    public fun runner(): u8 {
        let c = Container {a: 42, b: 100, c: 200, d: 255};
        let a_val = pattern_match_ignore_fields(c);

        let min_val = choose_min_example();

        // Return sum of extracted field and chosen min to make sure both run
        a_val + min_val
    }
}

//# run 0xCAFE::QuantifierTest::choose_min_example

//# run 0xCAFE::QuantifierTest::pattern_match_ignore_fields --args 55u8 0u8 0u8 0u8

//# run 0xCAFE::QuantifierTest::runner


//# publish
module 0xCAFE::ImportedModuleConsumer {
    use std::vector;
    // Importing std::math module from pre-compiled stdlib to call sqrt
    use std::math;

    public fun usage_of_imported_module(x: u64): u64 {
        let sq_root = math::sqrt(x);
        sq_root
    }
}

//# run 0xCAFE::ImportedModuleConsumer::usage_of_imported_module --args 100u64

// Featurres:
// 6d83e104e08118aa50a2c5bc116f8138: Use 'choose min' quantifiers to select the minimal value satisfying a given condition.
// a56262b170f67b534296aa6ded7843c2: Use '..' (dotdot) syntax in pattern matching to ignore the remaining fields of a struct.
// 31e040234cbac2ec3c9e51a2d34acd17: Import modules from pre-compiled libraries into your Move package.
