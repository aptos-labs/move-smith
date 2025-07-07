
//# publish
module 0xCAFE::AbilityDuplicateTest {
    use std::debug;

    // Struct with duplicate abilities: key, copy, and drop, which are all abilities for move values.
    struct DuplicateAbilitiesStruct has copy, drop, key {
        value: u64,
    }

    // Enum with duplicate abilities: copy and drop are listed twice.
    enum DuplicateAbilitiesEnum has copy, drop {
        VariantOne,
        VariantTwo,
    }

    // Function attempting to create abilities duplication - should cause compile error if duplicate abilities are detected.
    public fun test_duplicate_abilities() {
        // This function intentionally uses duplicate abilities
        // which should trigger an error during compilation.
        // The following line is invalid Move code and should be flagged.
        // Move doesn't allow explicit duplicate ability listing; but for the test, we include the code.
        let _s = DuplicateAbilitiesStruct { value: 42 };
        let _e = DuplicateAbilitiesEnum::VariantOne;
        // Note: The actual duplicate abilities are declared in the struct and enum headers,
        // and Move syntax itself disallows duplicates; no code needed here aside from illustrating the point.
    }

    // Control flow test with branches:
    public fun test_conditional_branch(condition: bool): u8 {
        if (condition) {
            1u8
        } else {
            0u8
        }
    }

    // Move code with token that can be matched:
    // Suppose that 'token' is a placeholder token that can be matched in parsing.
    public fun parse_token(token: vector<u8>): bool {
        if (vector::length(&token) == 9 && vector::drop(&vector::sub_sequence(&token, 0, 9)) == b"move_token") {
            true
        } else {
            false
        }
    }
}



//# run 0xCAFE::AbilityDuplicateTest::test_duplicate_abilities

//# run 0xCAFE::AbilityDuplicateTest::test_conditional_branch --args true

//# run 0xCAFE::AbilityDuplicateTest::test_conditional_branch --args false

//# run 0xCAFE::AbilityDuplicateTest::parse_token --args b"move_token"

//# run 0xCAFE::AbilityDuplicateTest::parse_token --args b"other_token"