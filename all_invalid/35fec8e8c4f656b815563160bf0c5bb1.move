
//# publish
module 0xCAFE::BitwiseOperatorsTest {
    use std::vector;

    // Recursive structure checker: we create a nested enum and recursive functions
    struct NestedStruct has copy, drop, store {
        level: u8,
        nested: option<NestedStruct>,
    }

    // Function to verify nested structures
    public fun check_nested(n: &NestedStruct): bool {
        if (n.level == 0) {
            true
        } else {
            match &n.nested {
                option::some(n2) => {
                    // Confirm nested level decreased by 1
                    if (n2.level + 1 == n.level) {
                        check_nested(n2)
                    } else {
                        false
                    }
                }
                option::none => n.level == 1,
            }
        }
    }

    // Function to create nested structures
    public fun create_nested(level: u8): NestedStruct {
        if (level == 0) {
            NestedStruct { level, nested: option::none() }
        } else {
            let nested_struct = create_nested(level - 1);
            NestedStruct { level, nested: option::some(nested_struct) }
        }
    }

    public fun test_recursive_structure() {
        let nested = create_nested(3);
        let result = check_nested(&nested);
        assert!(result, 999);
    }

    // Testing bitwise operators for various unsigned integer types with specific test cases
    // Use constants for various test values
    const ZERO_U8: u8 = 0;
    const MAX_U8: u8 = 255;
    const ONE_U8: u8 = 1;

    const ZERO_U16: u16 = 0;
    const MAX_U16: u16 = 65535;
    const ONE_U16: u16 = 1;

    const ZERO_U32: u32 = 0;
    const MAX_U32: u32 = 4294967295;
    const ONE_U32: u32 = 1;

    const ZERO_U64: u64 = 0;
    const MAX_U64: u64 = 18446744073709551615;
    const ONE_U64: u64 = 1;

    const ZERO_U128: u128 = 0;
    const MAX_U128: u128 = 340282366920938463463374607431768211455;
    const ONE_U128: u128 = 1;

    // For u256, define manually: max value (2^256 -1)
    const MAX_U256: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    const ZERO_U256: u256 = 0;
    const ONE_U256: u256 = 1;

    // Function to test bitwise AND, OR, XOR for all types
    public fun test_bitwise_ops_u8() {
        let a = ZERO_U8;
        let b = MAX_U8;
        let c = ONE_U8;
        // AND
        assert!(a & a == a, 1000);
        assert!(b & b == b, 1001);
        assert!(c & c == c, 1002);
        assert!(b & c == c, 1003);
        // OR
        assert!(a | a == a, 1004);
        assert!(b | b == b, 1005);
        assert!(c | c == c, 1006);
        assert!(a | c == c, 1007);
        // XOR
        assert!(a ^ a == a, 1008);
        assert!(b ^ b == a, 1009);
        assert!(c ^ c == a, 1010);
        assert!(b ^ c == (b & !c) | (!b & c), 1011);
    }

    public fun test_bitwise_ops_u16() {
        let a = ZERO_U16;
        let b = MAX_U16;
        let c = ONE_U16;
        // AND
        assert!(a & a == a, 1020);
        assert!(b & b == b, 1021);
        assert!(c & c == c, 1022);
        assert!(b & c == c, 1023);
        // OR
        assert!(a | a == a, 1024);
        assert!(b | b == b, 1025);
        assert!(c | c == c, 1026);
        assert!(a | c == c, 1027);
        // XOR
        assert!(a ^ a == a, 1028);
        assert!(b ^ b == a, 1029);
        assert!(c ^ c == a, 1030);
        assert!(b ^ c == (b & !c) | (!b & c), 1031);
    }

    public fun test_bitwise_ops_u32() {
        let a = ZERO_U32;
        let b = MAX_U32;
        let c = ONE_U32;
        // AND
        assert!(a & a == a, 1040);
        assert!(b & b == b, 1041);
        assert!(c & c == c, 1042);
        assert!(b & c == c, 1043);
        // OR
        assert!(a | a == a, 1044);
        assert!(b | b == b, 1045);
        assert!(c | c == c, 1046);
        assert!(a | c == c, 1047);
        // XOR
        assert!(a ^ a == a, 1048);
        assert!(b ^ b == a, 1049);
        assert!(c ^ c == a, 1050);
        assert!(b ^ c == (b & !c) | (!b & c), 1051);
    }

    public fun test_bitwise_ops_u64() {
        let a = ZERO_U64;
        let b = MAX_U64;
        let c = ONE_U64;
        // AND
        assert!(a & a == a, 1060);
        assert!(b & b == b, 1061);
        assert!(c & c == c, 1062);
        assert!(b & c == c, 1063);
        // OR
        assert!(a | a == a, 1064);
        assert!(b | b == b, 1065);
        assert!(c | c == c, 1066);
        assert!(a | c == c, 1067);
        // XOR
        assert!(a ^ a == a, 1068);
        assert!(b ^ b == a, 1069);
        assert!(c ^ c == a, 1070);
        assert!(b ^ c == (b & !c) | (!b & c), 1071);
    }

    public fun test_bitwise_ops_u128() {
        let a = ZERO_U128;
        let b = MAX_U128;
        let c = ONE_U128;
        // AND
        assert!(a & a == a, 1080);
        assert!(b & b == b, 1081);
        assert!(c & c == c, 1082);
        assert!(b & c == c, 1083);
        // OR
        assert!(a | a == a, 1084);
        assert!(b | b == b, 1085);
        assert!(c | c == c, 1086);
        assert!(a | c == c, 1087);
        // XOR
        assert!(a ^ a == a, 1088);
        assert!(b ^ b == a, 1089);
        assert!(c ^ c == a, 1090);
        assert!(b ^ c == (b & !c) | (!b & c), 1091);
    }

    public fun test_bitwise_ops_u256() {
        let a = ZERO_U256;
        let b = MAX_U256;
        let c = ONE_U256;
        // AND
        assert!(a & a == a, 1100);
        assert!(b & b == b, 1101);
        assert!(c & c == c, 1102);
        assert!(b & c == c, 1103);
        // OR
        assert!(a | a == a, 1104);
        assert!(b | b == b, 1105);
        assert!(c | c == c, 1106);
        assert!(a | c == c, 1107);
        // XOR
        assert!(a ^ a == a, 1108);
        assert!(b ^ b == a, 1109);
        assert!(c ^ c == a, 1110);
        assert!(b ^ c == (b & !c) | (!b & c), 1111);
    }

    // Runner to execute all tests
    public fun run_all_tests() {
        test_recursive_structure();
        test_bitwise_ops_u8();
        test_bitwise_ops_u16();
        test_bitwise_ops_u32();
        test_bitwise_ops_u64();
        test_bitwise_ops_u128();
        test_bitwise_ops_u256();
    }
}


//# run 0xCAFE::BitwiseOperatorsTest::run_all_tests

// Featurres:
// b0ed106f498d18741d0847243d2837a7: Use 'continue' with optional labels.
// c1d6ce0b3f7643dd3e81334940d5f993: Initialize and run a recursive structure checker on targeted modules.
// 6b2f6f761ce31c6627fbc6c3f231cd53: Test that the bitwise AND (&), OR (|), and XOR (^) operators produce correct results for all unsigned integer types (u8, u16, u32, u64, u128, and u256) on zero, identical, maximal, and mixed-value operands.
