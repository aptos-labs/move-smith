
//# publish
module 0xCAFE::LintSuppressor {
    // This module tests suppressing specific expression lint checks by skip list.

    use std::vector;

    public fun test_skip_expr_lints() {
        // Simulate skipping some lint checks by doing some undesirable operations but suppressed.
        // Example: unused variable, dead code, etc.
        let _unused_var = 123u64;

        if (false) {
            let _dead_code = 1u8;
            // Add some usage to avoid "unused variable" lint in the dead code block (Just for the test)
            assert!(_dead_code == 1, 0);
        };

        // Use a vector but do nothing with it (suppress unused vector lint)
        let _v = vector::empty<u8>();

        // Suppressing lint related to unused variable or dead code by "skip list"
        // (simulation because actual lint suppression is on compiler side)
    }
}



//# run 0xCAFE::LintSuppressor::test_skip_expr_lints



//# publish
module 0xCAFE::AbilitiesToSet {
    // Convert type parameter abilities list into set-based representation.

    // Ability mask representation:
    // immutable = 1,
    // store = 2,
    // copy = 4,
    // drop = 8,
    // key = 16,
    // All abilities can be combined by bitwise or.

    // Function to get ability mask sum from booleans.
    public fun abilities_to_bitmask(cpy: bool, drop: bool, store: bool, key: bool): u8 {
        let mask = 0u8;
        if (cpy) {
            mask = mask | 4u8;
        };
        if (drop) {
            mask = mask | 8u8;
        };
        if (store) {
            mask = mask | 2u8;
        };
        if (key) {
            mask = mask | 16u8;
        };
        mask
    }

    public fun abilities_from_list(abilities: vector<u8>): u8 {
        // Sum the abilities bits from the list (assuming list of ability values like 4,8,...)
        let acc = 0u8;
        let i = 0;
        let len = vector::length(&abilities);
        while (i < len) {
            acc = acc | *vector::borrow(&abilities, i);
            i = i + 1;
        };
        acc
    }

    public fun runner() {
        let list = vector[4u8, 8u8, 2u8];
        let total = abilities_from_list(list);
        let _ = abilities_to_bitmask(true, true, false, false);
        let _ = total;
    }
}



//# run 0xCAFE::AbilitiesToSet::runner


address 0xCAFE {
    

//# publish
    module AddressBlockModule {
        // This module is declared inside address block 0xCAFE to test address scoping

        public fun get_magic(): u32 {
            0xCADE
        }
    }
}



//# run 0xCAFE::AddressBlockModule::get_magic
