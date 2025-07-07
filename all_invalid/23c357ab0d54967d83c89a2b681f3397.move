
//# publish
module 0xBADD::DeprecationTest {
    use std::vector;

    // Attribute to deprecate the module, should be recognized but do nothing at runtime
    // deprecated]
//# publish
    module 0xDEAD::OldModule {
        struct Data has copy, drop, store {
            value: u64
        }

        public fun get_value(d: &Data): u64 {
            d.value
        }
    }

    // Attribute with an unknown attribute, to test warning detection
    // unknown_attribute]
//# publish
    module 0xBADD::UnknownAttrModule {
        struct Data has copy, drop, store {
            value: u32
        }
        
        public fun get_value(d: &Data): u32 {
            d.value
        }
    }

    // Function testing variable self-assignment in branches
    public fun test_self_assignment_in_branches(flag: bool): u64 {
        let x = 0u64;
        if (flag) {
            // Assign x to itself multiple times in if branch
            x = x;
            x = x;
        } else {
            // Assign x to itself multiple times in else branch
            x = x;
            x = x;
        };
        // The value of x should remain unchanged
        x
    }
}


//# run 0xBADD::DeprecationTest::test_self_assignment_in_branches --args true


//# run 0xBADD::DeprecationTest::test_self_assignment_in_branches --args false


// Featurres:
// d491b3262bf132a6ae19acd528b3d2fe: Deprecate entire modules using annotation attributes
// 4e108418b93ef93be1be7c3cad4822a8: Detect and warn about unknown attributes unless skipped by compiler flags.
// f0a90e1b880f018d7976fefd57824345: Test that assigning a variable to itself multiple times within different branches of an if-else statement does not affect the function’s correctness or return value.
