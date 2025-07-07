
//# publish
module 0xCAFE::Arithmetic {
    public fun add_two_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        // return sum plus a fixed value (5) to distinguish
        sum + 5
    }

    public inline fun inline_increment(a: u16): u16 {
        a + 1
    }

    public fun nested_inline_calls(a: u16): u16 {
        // call inline function inline_increment and add another 10
        let incremented = inline_increment(a);
        incremented + 10
    }
}


//# run 0xCAFE::Arithmetic::add_two_u8 --args 10u8 20u8


//# run 0xCAFE::Arithmetic::nested_inline_calls --args 5u16



//# publish
module 0xCAFE::ParserUsage {
    use std::string;
    use 0xCAFE::Arithmetic;

    // This function simulates parsing a number string into a u8 value
    public fun parse_value(data: vector<u8>): u8 {
        // If data exactly equals to "42", return 42u8, else 0
        if (data == b"42") {
            42u8
        } else {
            0u8
        }
    }

    public fun test_parse_and_add(data: vector<u8>, y: u8): u8 {
        let x = parse_value(data);
        Arithmetic::add_two_u8(x, y)
    }
}


//# run 0xCAFE::ParserUsage::parse_value --args b"42"


//# run 0xCAFE::ParserUsage::parse_value --args b"not_a_number"


//# run 0xCAFE::ParserUsage::test_parse_and_add --args b"42" 10u8



//# publish
module 0xCAFE::BitwiseTest {
    public fun bitwise_and_u8(a: u8, b: u8): u8 {
        a & b
    }

    public fun bitwise_or_u16(a: u16, b: u16): u16 {
        a | b
    }

    public fun bitwise_xor_u64(a: u64, b: u64): u64 {
        a ^ b
    }

    // test boundary cases with 0 and max values
    public fun test_edge_cases(): (u8, u16, u64) {
        let and_result = bitwise_and_u8(0xff, 0x0f);
        let or_result = bitwise_or_u16(0x0, 0xffff);
        let xor_result = bitwise_xor_u64(0xffff_ffff_ffff_ffff, 0xffff_ffff_0000_0000);
        (and_result, or_result, xor_result)
    }
}


//# run 0xCAFE::BitwiseTest::bitwise_and_u8 --args 0b10101010u8 0b11001100u8


//# run 0xCAFE::BitwiseTest::bitwise_or_u16 --args 0x0f0fu16 0xf0f0u16


//# run 0xCAFE::BitwiseTest::bitwise_xor_u64 --args 0xffff0000ffff0000u64 0x0000ffff0000ffffu64


//# run 0xCAFE::BitwiseTest::test_edge_cases


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// da8fdb73e01655ab5500e01c4e73ee1b: Optionally use wildcard segments in name paths depending on context
// 23482b3578da0ba999fc54c7f0f1b974: Use the parse_value function to parse a value from a token stream, expecting the token to represent a valid Value according to the language syntax.
// e15062c376176663d232358c3fc503fd: Test that the bitwise operators AND, OR, and XOR behave correctly across various unsigned integer types and edge cases in Move scripts.
