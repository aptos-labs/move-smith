//# publish
module 0xCAFE::VisibilityAndMatch {
    /// This struct has no visibility modifier, default is private to module
    struct PrivateStruct has copy, drop, store {
        value: u64
    }

    /// This struct is declared with public visibility
    public struct PublicStruct has copy, drop, store {
        pub_value: u64
    }

    /// Function to show usage of match-expression returning an integer
    public fun match_example(x: u8): u8 {
        match (x) {
            0 => 0,
            1 => 1,
            _ => 2,
        }
    }

    /// Returns a tuple indicating whether the structs have expected values
    public fun test_structs(): (u64, u64) {
        let private_inst = PrivateStruct { value: 123 };
        let public_inst = PublicStruct { pub_value: 456 };
        (private_inst.value, public_inst.pub_value)
    }
}

//# run 0xCAFE::VisibilityAndMatch::match_example --args 0u8

//# run 0xCAFE::VisibilityAndMatch::match_example --args 1u8

//# run 0xCAFE::VisibilityAndMatch::match_example --args 99u8

//# run 0xCAFE::VisibilityAndMatch::test_structs

// Featurres:
// 463704731de72a5dd17e1a544a91c23d: Declare a struct with optional visibility modifiers, enforcing that visibility modifiers are only allowed when language v2 is enabled.
// 83912fdc6382382415b69f3ad5d26f47: Use 'match' expressions for pattern matching inside expressions.
// 19657f4e140dd59df743a6ba2b8514a4: Declare functions with public visibility that can be called from any module.
