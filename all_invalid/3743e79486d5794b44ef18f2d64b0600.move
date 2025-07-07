//# publish
module 0xCAFE::QuantifierTest {
    struct Container has store {
        a: u8,
        b: u8,
        c: u8,
        d: u8,
    }

    /// Returns minimal u8 value where value > 5 and value < 10
    public fun choose_min_example(): u8 {
        // fix: use 'where' instead of 'such that'
        let min = choose min x: u8 where x > 5 && x < 10;
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
    // Removed unused std::vector import
    // Fix import of std::math to address unbound module error
    use std::math;

    public fun usage_of_imported_module(x: u64): u64 {
        let sq_root = math::sqrt(x);
        sq_root
    }
}

//# run 0xCAFE::ImportedModuleConsumer::usage_of_imported_module --args 100u64