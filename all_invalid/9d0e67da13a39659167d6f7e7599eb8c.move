
//# publish
module 0xCAFE::TestModule {
    use std::vector;
    use std::string;
    use std::signer;

    // This module is just a placeholder to declare addresses for the test.
}


//# run 0xCAFE::TestModule::dummy --signers 0xBADD


//# run
script {
    // Step 1: Extract addresses from module declarations (represented as string constants here)
    // In actual scenarios, addresses are from module specs; simulate by defining explicit addresses.
    let module_addr_a = @0xDEAD;
    let module_addr_b = @0xBEEF;

    // Step 2: Update addresses into new definitions
    let new_addr_a = @0xFEED;
    let new_addr_b = @0xFACE;

    // Wrap and store them as stored addresses
    let stored_addr_a = new_addr_a;
    let stored_addr_b = new_addr_b;

    // Verify the addresses match expected versions
    assert!(stored_addr_a == @0xFEED, 999);
    assert!(stored_addr_b == @0xFACE, 999);
}


//# publish
module 0xCAFE::SpecAndShadow {
    // Spec definitions (simulate inline with native recognition)
    // Since Move does not have native spec functions, simulate via functions marked as native
    native fun spec_function(x: u64): u64;
    fun user_defined_func(y: u64): u64 {
        y + 10
    }

    // Outer variables
    let outer_var1: u64 = 100;
    let outer_var2: u64 = 200;

    // Inline function that shadows outer_var1
    fun shadowing_function() {
        // Local variable with same name as outer
        let outer_var1: u64 = 555;
        // Assign to local variable
        outer_var1 = outer_var1 + 1;
        // After function, outer outer_var1 remains unchanged
        // (No direct modification to outer variable in outer scope)
    }

    // Runner to invoke the shadowing function and then check outer vars
    public fun run_shadow_test() {
        shadowing_function();
        // After calling, verify outer vars remain unchanged
        assert!(outer_var1 == 100, 1001);
        assert!(outer_var2 == 200, 1002);
        // Now modify outer_var1 and outer_var2
        outer_var1 = outer_var1 + 50;
        outer_var2 = outer_var2 + 50;
        // Final assertions
        assert!(outer_var1 == 150, 1003);
        assert!(outer_var2 == 250, 1004);
    }

    // Function illustrating variable value change with scope shadowing
    public fun scope_shadowing_example() {
        let outer_x: u64 = 10;
        // Inline inner scope with shadowed variable
        {
            let outer_x: u64 = 20; // shadows outer_x
            outer_x = outer_x + 5; // modifies local outer_x
        }
        // After inner scope, outer_x remains unchanged
        assert!(outer_x == 10, 1005);
        // Now change outer_x in outer scope
        outer_x = outer_x + 15;
        assert!(outer_x == 25, 1006);
    }
}


//# run 0xCAFE::SpecAndShadow::run_shadow_test --signers 0xAAA0


//# run 0xCAFE::SpecAndShadow::scope_shadowing_example --signers 0xAAA0


// Featurres:
// 127fdbb7d820b0c1d016477575c50ee0: Wrap address definitions with their modules into updated address definitions after extraction.
// f3a04639cbf00572c112bac1cda633ed: Define specification functions or native specification functions using the 'fun' or 'native' keywords in spec blocks.
// 692a2a16b2ecd52066ea81b7e14d92c6: Test that inner variable names shadow outer variables correctly and that assignments within inline functions update the outer bindings as expected.
