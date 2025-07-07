//# publish
module 0xBADD::DeprecationTest {
    use std::vector;

    // The deprecation attribute was incorrectly formatted and placed outside a module body.
    // Move the deprecated attribute comments inside the module, or remove the invalid tokens.
    // Also, the original comments with attributes are invalid Move syntax; they should be part of comments only.
    // Remove invalid attribute comments from the code.

    // Corrected code:

    
//# publish
    module 0xDEAD::OldModule {
        struct Data has copy, drop, store {
            value: u64
        }

        public fun get_value(d: &Data): u64 {
            d.value
        }
    }

    
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
        let x = 0u64; // Declare x as mutable
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
