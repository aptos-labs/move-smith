
//# publish
module 0xCAFE::VerificationTest {
    use std::vector;

    // Enable verification with a pragma
    pragma verification;
    
    // Define a struct with verification annotations
    // verification(readable)]
    struct VerifiedStruct has store, key {
        value: u64,
    }

    // Define an enum with verification attributes
    // verification(noise)]
    enum VerifiedEnum has copy, drop {
        VariantA,
        VariantB(u8),
    }

    // Verify that the struct enforces read/write rules
    public fun create_verified_struct(x: u64): VerifiedStruct {
        let s = VerifiedStruct { value: x };
        s
    }

    // Function to test match with rest pattern
    public fun match_with_rest(input: vector<u8>): u8 {
        match (input) {
            v if vector::length(&v) == 0 => 0,
            v if vector::length(&v) == 1 => *vector::borrow(&v, 0),
            v => {
                // Rest pattern: match all but the first element
                let rest = vector::drop(&v, 1);
                // Sum of first element and length of rest
                let first = *vector::borrow(&v, 0);
                first + vector::length(&rest) as u8
            }
        }
    }

    // Function with rest pattern in binding matching a vector of 3 elements
    public fun match_rest_pattern(): u64 {
        let all = vector::from(vec![10u64, 20u64, 30u64]);
        match (all) {
            v if vector::length(&v) == 3 => {
                let [first, .., last] = v; // rest pattern matching all but first and last
                first + last
            }
            _ => 0,
        }
    }

    // Function that uses annotated inline verification
    public inline fun annotated_inline(x: u32): u32 {
        // verification target: ensure value is less than 1000
        // verification( ensures = "x < 1000" )]
        let y = x + 1;
        y
    }

    // Function to test pattern with nested rest pattern and enum
    public fun nested_match(e: VerifiedEnum): u32 {
        match (e) {
            VerifiedEnum::VariantA => 1,
            VerifiedEnum::VariantB(n) => n as u32,
        }
    }
}


//# run 0xCAFE::VerificationTest::create_verified_struct --args 42


//# run 0xCAFE::VerificationTest::match_with_rest --args [10, 20, 30]

 
//# run 0xCAFE::VerificationTest::match_rest_pattern


//# run 0xCAFE::VerificationTest::nested_match --args VerifiedEnum::VariantB(5)

// Featurres:
// dc7f4eb8ee521a0f4b662a44aa17f7a7: Annotate Move code items with #[verification(...)] attributes to provide verification-related metadata.
// f94576fe76fd284416a605c3e0607384: Add pragmas to guide verification or compilation.
// 028ba79c0d2d6550c16b84253f99819a: Use '..' patterns in Move code to match an unspecified or rest pattern in bindings.
