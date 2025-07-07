// SPDX-License-Identifier: Apache-2.0

// 0xCAFE will be used as test address

//# publish
#[verification(not_a_test)]
module 0xCAFE::MatchRangeAndSpec {
    use std::signer;
    use std::vector;

    #[verification(spec)]
    struct SpecData has copy, drop, store {
        a: u8,
        b: u64
    }

    /// This function tests matching a range using '..' in patterns
    public fun test_match_range(x: u8): u8 {
        // The pattern uses a range pattern 1..=10 (1 to 10 inclusive) with '..'
        // '..' inside a pattern act as a range in Move
        match x {
            0 => 0,
            1..=10 => 1,
            11..=20 => 2,
            _ => 3,
        }
    }

    /// This function destructures a tuple using '..' pattern to discard tail
    public fun test_match_destructure(vec: vector<u8>): u8 {
        // If vector length >= 2 and first two bytes are 1 and 2, return 42 else 0
        if (vector::length(&vec) >= 2) {
            match &vec {
                // Notice '..' after first two elements, discard rest of vector
                [1, 2, ..] => 42,
                _ => 0,
            }
        } else {
            0
        }
    }

    #[verification(spec)]
    spec module {
        static mut spec_data: SpecData;
    }

    #[verification(spec)]
    spec test_match_range {
        // initialize spec_data before test
        initialize {
            update spec_data = SpecData { a: 0, b: 0 };
        }

        // This ensures update statement in spec works, set a = 5 and b = 10
        let new_a = 5;
        let new_b = 10;

        update spec_data = SpecData { a: new_a, b: new_b };
    }

    /// Runner function calls both test functions and returns combined result
    public fun runner(): u8 {
        let r1 = test_match_range(5);
        let r2 = test_match_destructure(vector::empty<u8>());
        r1 + r2
    }
}
//# run 0xCAFE::MatchRangeAndSpec::runner

//# publish
#[verification(not_a_test)]
module 0xCAFE::VerificationAttributes {
    use std::signer;

    /// A struct with copy ability to test verification attribute
    #[verification(level = 2, description = "Testing verification attributes on struct")]
    struct VerifyStruct has copy, drop {
        value: u64
    }

    /// A public function annotated with verification attribute to test metadata is accepted
    #[verification(author = "test", level = 1)]
    public fun verified_function(x: u64): u64 {
        x + 1
    }

    /// Runner to call verified_function
    public fun runner(): u64 {
        verified_function(100)
    }
}
//# run 0xCAFE::VerificationAttributes::runner

// Featurres:
// e72b84369c14a4151f7774ba67c20ab9: Use '..' as a pattern in move match expressions or pattern matching syntax to specify a range or destructuring pattern.
// 87afaffcf5178ad4d1a06d462c3cb487: Assign specification values using 'update' statements in spec blocks
// dc7f4eb8ee521a0f4b662a44aa17f7a7: Annotate Move code items with #[verification(...)] attributes to provide verification-related metadata.
