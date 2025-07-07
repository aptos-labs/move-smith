
//# publish
module 0xCAFE::TestImportAlias {
    use 0xCAFE::MyModule as M;
    use std::vector;

    // Wrapper function to test alias import and generic visibility
    public fun run_import_and_access() {
        // Call function f1 with arguments
        let result_f1 = M::f1(5u8, true);

        // Call function f3 with argument
        let _s = M::f3(20u16);

        // Call function that tests import alias usage internally
        internal_test_alias_usage();

        // Test access using visible name
        let _x = M::f1(7u8, false);
    }

    // Function to test variable assignment after if-else
    public fun test_variable_assignment_in_if_else(cond: bool): u32 {
        // Declare a variable to hold the value
        let val: u32;

        if (cond) {
            let temp = 42u32;
            val = temp;
        } else {
            let temp = 99u32;
            val = temp;
        };
        // Return the value to test correctness
        val
    }

    // Internal function called within run_import_and_access
    fun internal_test_alias_usage() {
        let _ = M::f2(10u16);
        let e = M::E::V3 { a: true };
        let _ = match (e) {
            M::E::V1 => 1,
            M::E::V2(x, y) => x + y,
            M::E::V3 { a } => if (a) { 2 } else { 3 },
        };
    }
}


//# run 0xCAFE::TestImportAlias::run_import_and_access --signers 0xBADD --args

//# run 0xCAFE::TestImportAlias::test_variable_assignment_in_if_else --args true

//# run 0xCAFE::TestImportAlias::test_variable_assignment_in_if_else --args false

// Featurres:
// 183ecf11e40cd8fa5b885c8dfa839e08: Import modules or items using an alias with the 'use' statement in your Move code.
// e92862de9389bf90c5f10cdf195228a6: Attach optional type arguments to access specifiers for generic visibility control.
// c33a429a40f19f299f04ce6f4fed9a08: Test that variables can be assigned within an if-else statement and retain the correct value after the conditional branch.
