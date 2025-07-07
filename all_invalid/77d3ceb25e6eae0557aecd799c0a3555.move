
//# publish
module 0xBABA::TestModule {
    use std::signer;

    // test]
    public fun test_if_else_conditions() {
        let result_true = test_conditional(true);
        let result_false = test_conditional(false);
        // Not asserting, just calling functions to test compilation and VM execution
        result_true;
        result_false;
    }

    public fun test_conditional(cond: bool): u8 {
        let res = if (cond) {
            42u8
        } else {
            24u8
        };
        res
    }
}

/// Additional test for attribute annotations and function invocation

// test]
public fun test_attributes() {
    call_attribute_tests();
}

public fun call_attribute_tests() {
    // Just calling test functions to verify attribute effects
}


// Featurres:
// e1c3cb622fa8ea3df6f7d8e7ccca3131: Use attribute values to specify module references or names in Move code.
// d32bd826c9c658f1a41d3d18c744bcd7: Write `if-else` conditional expressions.
// 041592336dc733cbed8be719548559d4: Annotate functions or members with #[test] or #[test_only] attributes to mark them as test members.
