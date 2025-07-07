//# publish
module 0xCAFE::Multiple {

    enum MultiEnum has copy, drop {
        A,
        B(u32),
        C { flag: bool },
        D(u8, u8),
    }

    struct MultiStruct has copy, drop, store, key {
        p: u64,
        q: u128,
    }

    struct NestedStruct<T1, T2> has copy, drop {
        first: T1,
        second: T2,
    }

    public fun create_struct(): MultiStruct {
        MultiStruct { p: 42u64, q: 12345678901234567890u128 }
    }

    public fun create_nested_struct(): NestedStruct<u8, MultiStruct> {
        let inner = create_struct();
        NestedStruct { first: 255u8, second: inner }
    }

    public fun match_single_variant(e: MultiEnum): u8 {
        if (is e A) {
            1u8
        } else if (is e B) {
            2u8
        } else if (is e C) {
            3u8
        } else {
            4u8
        }
    }

    // Tests the 'is' operator with multiple enum variants by or-chain in if condition
    public fun match_multiple_variant(e: MultiEnum): u8 {
        if (is e A || is e B) {
            10u8
        } else if (is e C || is e D) {
            20u8
        } else {
            30u8
        }
    }

    public fun test_pattern_match(e: MultiEnum): u8 {
        // Use pattern matching with match for each variant
        let res = match (e) {
            MultiEnum::A => 100u8,
            MultiEnum::B(n) => 200u8 + (n as u8),
            MultiEnum::C { flag } => if (flag) { 300u8 } else { 400u8 },
            MultiEnum::D(x, y) => x + y,
        };
        res
    }

    public fun test_multiple_sequence() {
        let s1 = create_struct();
        let s2 = create_nested_struct();
        let _ = s1;
        let _ = s2;
    }
}

//# run 0xCAFE::Multiple::create_struct

//# run 0xCAFE::Multiple::create_nested_struct

//# run 0xCAFE::Multiple::match_single_variant --args 0  // Creating enum A as int 0 (simulate casting will not work, so use script instead)

//# run 0xCAFE::Multiple::match_multiple_variant --args 3 // enum C variant index 2, here args for enum is tricky, use script below instead

//# publish
script {
    use 0xCAFE::Multiple;

    fun test_enum_variants() {
        let enum_a = Multiple::MultiEnum::A;
        let enum_b = Multiple::MultiEnum::B(7);
        let enum_c = Multiple::MultiEnum::C { flag: true };
        let enum_d = Multiple::MultiEnum::D(5, 10);

        let _ = Multiple::match_single_variant(enum_a);
        let _ = Multiple::match_single_variant(enum_b);
        let _ = Multiple::match_single_variant(enum_c);
        let _ = Multiple::match_single_variant(enum_d);

        let _ = Multiple::match_multiple_variant(enum_a);
        let _ = Multiple::match_multiple_variant(enum_b);
        let _ = Multiple::match_multiple_variant(enum_c);
        let _ = Multiple::match_multiple_variant(enum_d);

        let _ = Multiple::test_pattern_match(enum_a);
        let _ = Multiple::test_pattern_match(enum_b);
        let _ = Multiple::test_pattern_match(enum_c);
        let _ = Multiple::test_pattern_match(enum_d);

        Multiple::test_multiple_sequence();
    }

    fun main() {
        test_enum_variants();
    }
}

//# run 0xCAFE::Multiple::main

// Featurres:
// c423383e13619580fa0d6477f9a16cca: Create multiple types in a sequence with 'Multiple'.
// f54e4fa5c5679cd310463059f6e39fe7: Test that the enum variant match operator `(is)` correctly recognizes single and multiple enum variants in pattern matching.
// b237ce38fd06c6af48aa07c5b6bd1b22: Follow naming conventions for module members to ensure compatibility and avoid conflicts.
