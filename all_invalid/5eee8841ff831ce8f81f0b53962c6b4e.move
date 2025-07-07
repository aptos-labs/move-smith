//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // A struct to use as a return and arg example
    struct Data has copy, drop, store {
        x: u64,
        y: u8,
    }

    /// Public function using named parameters and results
    public fun named_params_results(value: u64, flag: bool): (result1: u64, result2: bool) {
        let r1 = value + 1;
        let r2 = !flag;
        (r1, r2)
    }

    /// Runner function to call named_params_results with fixed values
    public fun runner(): (u64, bool) {
        Self::named_params_results(value: 42, flag: true)
    }

    #[spec]
    fun spec_example() {
        let a: u64;
        let b: u64;

        a = 5;
        b = a + 10;
    }
}

//# run 0xCAFE::TestModule::runner

//# publish
module 0xCAFE::ParseValueTest {
    use std::string;
    use std::vector;

    // Struct representing a parsed value
    struct Value has copy, store, drop {
        v: u64,
    }

    /// Dummy parse_value function simulating parsing a token stream
    /// For this test, the input token is a vector<u8> simulating ASCII digits, returning Value
    public fun parse_value(token_stream: vector<u8>): Value acquires Value {
        // Convert token_stream (ASCII digits) to u64 value
        let mut val: u64 = 0;
        let len = vector::length(&token_stream);
        let mut i = 0;
        while (i < len) {
            let digit = vector::borrow(&token_stream, i);
            let digit_val = (*digit - 48) as u64; // '0' ascii is 48
            val = val * 10 + digit_val;
            i = i + 1;
        }
        Value { v: val }
    }

    /// Runner to test parse_value
    public fun runner() {
        let token_stream = b"1234";
        let value = Self::parse_value(token_stream);
        // Normally would assert or use value, but for test just run
    }
}

//# run 0xCAFE::ParseValueTest::runner

//# run 0xCAFE::TestModule::spec_example

// Featurres:
// 23482b3578da0ba999fc54c7f0f1b974: Use the parse_value function to parse a value from a token stream, expecting the token to represent a valid Value according to the language syntax.
// 4ee2a0b08f4677e897745bd9fd7b3e2e: Use named parameters and results in functions
// 7cc49543fa09eb05657b36151d8d9960: Write specification block update statements that assign one expression to another using the '=' syntax inside Move spec blocks
