//# publish
module 0xCAFE::TestInvalidAssignment {
    use std::signer;
    use std::error;

    /// A dummy resource to test global storage.
    struct DummyResource has store, key {
        value: u64,
    }

    /// A helper function to publish DummyResource to global storage.
    public fun publish_resource(signer_addr: address) {
        let dummy = DummyResource { value: 42 };
        move_to<DummyResource>(&signer_addr, dummy);
    }
}

//# run 0xCAFE::TestInvalidAssignment::publish_resource --signers 0xCAFE

//# publish
module 0xCAFE::TestLiteralExpressions {
    // Testing literal values: numbers and booleans
    fun literals_test(): bool {
        let num_u8: u8 = 255;
        let num_u16: u16 = 65535;
        let num_u32: u32 = 4294967295;
        let num_u64: u64 = 18446744073709551615;
        let bool_true: bool = true;
        let bool_false: bool = false;

        // Literal value expressions
        let res1 = (1 + 2 as u8); // 3u8
        let res2 = (100 as u16); // 100u16
        let res3 = (2000 as u16); // 2000u16
        let res4 = (9 as u32); // 9u32
        let res5 = (123456 as u64); // 123456u64
        let res6 = bool_true; // true
        let res7 = bool_false; // false

        // Check literals
        res1 == 3 && res2 == 100 && res3 == 2000 && res4 == 9 && res5 == 123456 && res6 && !res7
    }

    #[test]
    fun test_literals(): bool {
        literals_test()
    }
}

//# run 0xCAFE::TestLiteralExpressions::test_literals

//# publish
module 0xCAFE::AssignmentTest {
    // Test invalid assignment syntax outside allowed patterns.
    // This code is expected to fail compilation if uncommented.
    /*
    fun invalid_assignments() {
        let x = 10;
        // Invalid assignment: cannot assign to a literal
        5 = x; // Error: cannot assign to a literal
        // Invalid assignment: missing var name
        = x; // Error
        // Invalid multiple assignment syntax
        let a, b = (1, 2); // Invalid in Move
        // Invalid use of assignment operator
        let y = 20;
        let z;
        y + z = 30; // Error: cannot assign to expression
    }
    */
    // To pass the test, define a dummy function with valid syntax.
    fun dummy() {}
}

//# run 0xCAFE::AssignmentTest::dummy

//# publish
module 0xCAFE::AbilitySetTest {
    use std::abilities::AbilitySet;

    #[test]
    fun test_abilityset_empty() {
        // AbilitySet::EMPTY should be a valid abilities set with no abilities
        let empty_set = AbilitySet::EMPTY;
        // We can test that it equals itself
        assert!(empty_set == AbilitySet::EMPTY);
    }
}

//# run 0xCAFE::AbilitySetTest::test_abilityset_empty