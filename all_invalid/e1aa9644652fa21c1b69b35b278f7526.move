
//# publish
module 0xCAFE::TestImportAlias {
    use 0xYourModule::MyModule as M; // Replace 0xYourModule with your actual module address where MyModule is defined
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