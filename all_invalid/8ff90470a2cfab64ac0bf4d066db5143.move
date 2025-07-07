
//# publish
module 0xBADD::DeprecationTest {
    // Deprecated module to test annotation
    // deprecated]
    public fun deprecated_function(): bool {
        true
    }
}


//# publish
module 0xBADD::OuterScope {
    // Module to test variable shadowing and closure capture
    struct VarContainer has copy, drop {
        val: u64
    }

    public fun update_shadowed_variable() {
        let outer_var = 42u64;

        let closure = |new_val: u64| {
            // Shadow outer variable
            let outer_var = new_val;
            // Return the inner outer_var to verify capture
            outer_var
        };

        let _shadowed_value = closure(100u64);
        // The outer variable remains unchanged outside
        outer_var
    }
}


//# run 0xBADD::DeprecationTest::deprecated_function --args

//# run 0xBADD::OuterScope::update_shadowed_variable


// Featurres:
// a5d50289b47d654cefe150822aec7ef9: Test that the function returns 100 when the condition is true, regardless of the value assigned in the else branch.
// dffa67cb5913057d2fb5542cb75c7d68: Annotate modules with deprecation status to indicate they are deprecated.
// fff1c50f05bdffc971fc23cdc837a682: Verify that a variable defined in an outer scope can be correctly overwritten by a closure invoked within a function, ensuring proper variable shadowing and capture behavior.
