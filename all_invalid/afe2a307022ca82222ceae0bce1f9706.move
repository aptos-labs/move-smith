
//# publish
module 0xCAFE::test_module {

    // A struct to test storage and copy abilities
    struct TestStruct has copy, drop {
        value: u64,
    }

    // Function to test inline function parameter usage
    public inline fun check_inline(param: u64) {
        assert(param > 0, 101);
    }

    // Function to test references, especially &mut
    public fun test_reference_and_mut() {
        let x = 10;
        let ref_x = &mut x;
        *ref_x = 20; // mutate through reference
        assert(x == 20, 102);
    }

    // Function to test order of evaluation and mutation
    public fun test_order_of_evaluation() {
        let x = 5;
        let y = 10;

        // order should be: evaluate then mutate
        // Call with block expression that mutates x
        let result = if { x = x + 1; x } > y { 1 } else { 0 };
        assert(result == 0, 103);
        assert(x == 6, 104);

        // Use &mut reference and block together
        let ref_x = &mut x;
        *ref_x = *ref_x + 2;
        assert(x == 8, 105);
    }

    // Function to test list of trigger expressions
    public fun test_trigger_list() {
        let triggers = vector[{1u8, 2u8, 3u8}];
        assert(triggers.len() == 3, 106);
        assert(*vector::borrow(&triggers, 0) == 1u8, 107);
        assert(*vector::borrow(&triggers, 1) == 2u8, 108);
        assert(*vector::borrow(&triggers, 2) == 3u8, 109);
    }

    // Runner function for internal tests
    public fun run_all_tests() {
        check_inline(42);
        test_reference_and_mut();
        test_order_of_evaluation();
        test_trigger_list();
        let _instance = TestStruct { value: 999 };
    }
}


//# run 0xCAFE::test_module::run_all_tests --signers 0xCAFE

// Featurres:
// a6e3be8a5a53e05a06faffbeca8e166f: Specify triggers for quantifiers, possibly including a list of trigger expressions enclosed in braces.
// 057ed43b704e6042288e427679b31ffe: Ensure inline functions have their parameters properly checked for usage.
// 118a30f282208cbd9dfc2ac3ca907871: Test the correct order of evaluation and mutation for &mut references and block expressions in function calls and expressions.
