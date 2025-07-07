
//# publish
module 0xDEAD::EnumPatternMatching {
    // Examples of pattern matching on enums and structs, nested patterns, wildcards, and references.

    use std::option;
    use std::vector;

    struct InnerStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct OuterStruct has copy, drop, store {
        x: u32,
        y: Option<InnerStruct>,
    }

    enum MyEnum has copy, drop {
        Zero,
        One,
        TwoFields(u8, u8),
        NestedStruct(OuterStruct),
        Wildcard,
        GuardedCondition {
            flag: bool,
            data: Option<InnerStruct>,
        }
    }

    // Friend declaration with another module (simulate in the same module for testing)
    friend 0xCAFE;

    // Inline spec for some basic conditions
    spec {
        // This is a placeholder for the inline spec, the comments show intention
        // For real use, conditions can be expressed here
    }

    public fun match_enum(e: MyEnum): u8 {
        match (e) {
            MyEnum::Zero => 0,
            MyEnum::One => 1,
            MyEnum::TwoFields(a, b) => a + b,
            MyEnum::NestedStruct(s) => {
                // Match nested pattern inside struct
                match (s.y) {
                    option::Some(inner) => {
                        inner.a + inner.b
                    },
                    option::None => 255,
                }
            },
            MyEnum::Wildcard => 42,
            MyEnum::GuardedCondition { flag, data } => {
                if (flag) {
                    match (data) {
                        option::Some(inner) => inner.a,
                        option::None => 0,
                    }
                } else {
                    99
                }
            }
        }
    }
}

public fun test_matching_patterns() {
    // Testing various enum cases
    let result1 = 0xDEAD::EnumPatternMatching::match_enum(MyEnum::Zero);
    let result2 = 0xDEAD::EnumPatternMatching::match_enum(MyEnum::One);
    let result3 = 0xDEAD::EnumPatternMatching::match_enum(MyEnum::TwoFields(10, 20));
    let inner_struct = InnerStruct { a: 7, b: 8 };
    let outer_struct = OuterStruct { x: 0, y: option::Some(inner_struct) };
    let enum_nested = MyEnum::NestedStruct(outer_struct);
    let result4 = 0xDEAD::EnumPatternMatching::match_enum(enum_nested);
    let result5 = 0xDEAD::EnumPatternMatching::match_enum(MyEnum::Wildcard);
    let guarded_true = MyEnum::GuardedCondition { flag: true, data: option::Some(inner_struct) };
    let guarded_false = MyEnum::GuardedCondition { flag: false, data: option::None };
    let result6 = 0xDEAD::EnumPatternMatching::match_enum(guarded_true);
    let result7 = 0xDEAD::EnumPatternMatching::match_enum(guarded_false);
    // Use these results to verify pattern matching works as expected
    // As no assertions centered on data, just a composition of calls
}



//# run 0xDEAD::EnumPatternMatching::match_enum --args MyEnum::Zero

//# run 0xDEAD::EnumPatternMatching::match_enum --args MyEnum::One

//# run 0xDEAD::EnumPatternMatching::match_enum --args MyEnum::TwoFields(10, 20)

//# run 0xDEAD::EnumPatternMatching::match_enum --args MyEnum::NestedStruct(OuterStruct { x: 0, y: option::Some(InnerStruct { a: 7, b: 8 }) })

//# run 0xDEAD::EnumPatternMatching::match_enum --args MyEnum::Wildcard

//# run 0xDEAD::EnumPatternMatching::match_enum --args MyEnum::GuardedCondition { flag: true, data: option::Some(InnerStruct { a: 9, b: 10 }) }

//# run 0xDEAD::EnumPatternMatching::match_enum --args MyEnum::GuardedCondition { flag: false, data: option::None }

// Additional tests for module friends and inline specification expressions:

//# publish
module 0xCAFE::FriendAccess {
    // Declare other module as a friend
    friend 0xDEAD;

    public fun check_friend_visibility() {
        // This function can access private structure if friend
        // (In real scenario, verify access rights)
        // For testing, just a placeholder to simulate friend declaration effect.
        ()
    }
}



//# run 0xCAFE::FriendAccess::check_friend_visibility

// Tests for inline spec expressions but outside any spec block (mocked purpose)
spec {
    // The spec keyword here is for illustrative; relying on the behavior of external spec expressions
    // No actual runtime code; just a placeholder to respect structure
}
