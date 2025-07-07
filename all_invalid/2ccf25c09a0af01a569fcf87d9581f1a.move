
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // Structure for verification and specifications testing
    struct Data has store, key {
        id: u64,
        name: vector<u8>,
        active: bool,
    }

    // Enum illustrating pattern matching with conditionals
    enum ConditionEnum has copy, drop {
        VariantA,
        VariantB(u8),
        VariantC { flag: bool },
    }

    // Function using pattern matching with 'if' guard in arms
    public fun match_with_guard(val: u8, cond: ConditionEnum): u64 {
        match (cond) {
            ConditionEnum::VariantA if (val % 2 == 0) => 100,
            ConditionEnum::VariantB(x) if (x > 10) => 200,
            ConditionEnum::VariantC { flag } if (flag) => 300,
            _ => 400,
        }
    }

    // Function demonstrating multiple spec blocks with verification attributes
    // verifier::spec]
    public fun spec_func_one(x: u64): bool {
        x > 0
    }

    // verifier::spec]
    public fun spec_func_two(y: u64): bool {
        y < 100
    }

    // verifier::spec]
    public fun combined_spec(x: u64, y: u64): bool {
        spec_func_one(x) && spec_func_two(y)
    }

    // Function with custom verification attributes
    // verifier::disable_verify]
    public fun no_verify_func(s: vector<u8>): vector<u8> {
        s
    }

    // Function that creates multiple specifications
    public fun create_and_verify(id: u64, name: vector<u8>, flag: bool): Data {
        let data = Data {id, name, active: flag};
        data
    }

    // Function to test pattern match and verification integration
    public fun pattern_match_test(x: u8, cond: ConditionEnum): u64 {
        match_with_guard(x, cond)
    }

    // Function to test spec or custom attributes handling
    public fun verification_and_spec_test(x: u64, y: u64): (bool, bool) {
        (spec_func_one(x), spec_func_two(y))
    }
}


//# run 0xDEAD::TestModule::match_with_guard --args 4u8 ConditionEnum::VariantB(15)


//# run 0xDEAD::TestModule::create_and_verify --args 123u64 b"TestName" true


//# run 0xDEAD::TestModule::verification_and_spec_test --args 1u64 50u64


// Featurres:
// e046b2e91b3910c3dd96eb1be778c6ca: Use 'if' guard conditions in match arms to add conditional logic to pattern matching.
// da3924cbd53e41467f4ab97a7d45c3f1: Create specification blocks with multiple specification items.
// 5e57bd5da0005044c3de25974ad77f2f: Use custom verification attributes to control verification and analysis for code elements.
