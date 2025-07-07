
//# publish
module 0xCAFE::AbilityDuplicateTest {
    use std::debug;

    // Struct with duplicate abilities: key, copy, and drop, which are all abilities for move values.
    struct DuplicateAbilitiesStruct has copy, drop, key, copy {
        value: u64,
    }

    // Enum with duplicate abilities: copy and drop are listed twice.
    enum DuplicateAbilitiesEnum has copy, drop, copy {
        VariantOne,
        VariantTwo,
    }

    // Function attempting to create abilities duplication - should cause compile error if duplicate abilities are detected.
    public fun test_duplicate_abilities() {
        // This function intentionally uses duplicate abilities
        // which should trigger an error during compilation.
        // The following line is invalid Move code and should be flagged.
        let _s = DuplicateAbilitiesStruct { value: 42 };
        let _e = DuplicateAbilitiesEnum::VariantOne;
        // The abilities are declared duplicate at module level,
        // but in function context, abilities are part of struct/declaration.
        // Since Move doesn't allow explicit duplicate ability listing,
        // the above duplicate abilities declaration should cause compile error.
        // But for the purpose of the test, we just write the code that would be invalid if abilities are duplicated.
    }

    // Control flow test with branches:
    public fun test_conditional_branch(condition: bool): u8 {
        if (condition) {
            goto label_true;
        } else {
            goto label_false;
        };
        label_true:
            1u8
        label_false:
            0u8
    }

    // Move code with token that can be matched:
    // Suppose that 'token' is a placeholder token that can be matched in parsing.
    public fun parse_token(token: vector<u8>): bool {
        // Let's assume the token b"move_token" is accepted.
        // The move parser would match this token during parsing.
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

// Featurres:
// e5fe0227933449dc0c00c7c0a420afe8: Detect duplicate abilities in the same context and report errors
// 14993c742de74b563f9623fbba7a7bb3: Use conditional branches that direct control flow to one of two labels based on a condition in Move bytecode.
// 31c59413fbf6825ea085af5daa314568: Write Move code using tokens that can be recognized and matched during parsing.
