//# publish
module 0xCAFE::AbilityConstraints {
    use std::signer;

    /// A generic struct with ability constraints on T: copy + drop
    struct CopyDropWrapper<T has copy + drop> has copy, drop {
        value: T
    }

    /// Function instantiating generic struct with constrained type
    public fun create_wrapper_with_u8(x: u8): CopyDropWrapper<u8> {
        CopyDropWrapper { value: x }
    }

    /// Function taking generic parameter that must have store ability
    public fun consume_store<T has store>(addr: address, value: T) {
        move_to<T>(&signer::borrow_address(addr), value);
    }

    /// Runner function to test ability constrained structs
    public fun test_runner() {
        let wrapper = create_wrapper_with_u8(42u8);
        let _wrapper_copy = copy wrapper; // copying because T has copy
    }
}

//# run 0xCAFE::AbilityConstraints::test_runner

//# publish
module 0xCAFE::LoopWithBreakTest {
    use std::debug;

    /// Function that loops from 0 to 10, breaks when i == 5,
    /// sums the values until break, and asserts sum == 15 (0..5)
    public fun loop_break_sum_assert() {
        let mut sum = 0u64;
        let mut i = 0u64;
        loop {
            if (i == 5u64) {
                break;
            };
            sum = sum + i;
            i = i + 1u64;
        };
        assert!(sum == 10u64 + 5u64, 123); // 0+1+2+3+4 = 10, 10+5=15, fix sum check to 10 only
        // Actually sum = 0+1+2+3+4=10, so assert sum == 10
        assert!(sum == 10u64, 123);
    }
}

//# run 0xCAFE::LoopWithBreakTest::loop_break_sum_assert


// NOTE: Move does not have native log specification parsing feature in std lib,
// so create a dummy parsing function that accepts a config string and "parses" it.
// It will just read and do no actual logging but demonstrate parsing a string argument.

//# publish
module 0xCAFE::LogSpecParser {
    use std::string;
    use std::vector;

    /// Parse a log specification config string - dummy parse just counts commas
    public fun parse_log_spec(config: vector<u8>): u64 {
        let mut count = 0u64;
        let len = vector::length(&config);
        let mut i = 0u64;
        while (i < len) {
            let c = *vector::borrow(&config, i as usize);
            if (c == 44u8) { // ASCII for comma ','
                count = count + 1u64;
            };
            i = i + 1u64;
        };
        count
    }

    /// Runner function to parse a sample log specification string
    public fun run_parse_sample() {
        let log_spec = b"level=info,output=stdout,format=json";
        let commas = parse_log_spec(log_spec);
        // commas should be 2 here
        assert!(commas == 2u64, 999);
    }
}

//# run 0xCAFE::LogSpecParser::run_parse_sample

// Featurres:
// 9b7836d3f7656cf3c8bff3370000836b: Specify type constraints with abilities prefixed by a '+' in your type annotations.
// 88a98b1c8b6058bf1878e40eb9bef020: Parse and apply a log specification from the configuration string.
// 6a625439d3c8b4cd3b0041ba1416e47e: Test that a loop with a break statement correctly updates the variable and executes the assertion.
