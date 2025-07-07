//# publish
module 0x1::ClosureScopeTest {
    public fun test_mutate_closure_in_scope() {
        // Create a move-only closure with drop constraint
        let mut closure: || has drop = || {};
        // Outer scope
        {
            // Assign a new closure inside the scope
            *(&mut closure) = || {};
        }
        // Closure should still be valid here
        // Optionally, invoke closure to ensure it works (not required by test)
        // closure();
    }

    public fun test_copy_move_closure_within_nested_scopes() {
        // Create a move-only closure with copy + drop constraint
        let closure_copy: || has copy+drop = || {};
        // Outer scope
        {
            // Inner scope
            {
                // Assign a new closure to the copy closure
                *(&mut (closure_copy)) = || {};
            }
            // Use the closure after inner scope (not strictly required)
            // closure_copy();
        }
    }

    public fun test_closure_within_function_and_inner_scope() {
        // Create a move-only closure
        let mut outer_closure: || has drop = || {};
        // Assign a closure
        *(&mut outer_closure) = || {};
        // Inner scope
        {
            // Create and assign another closure inside inner scope
            let mut inner_closure: || has drop = || {};
            *(&mut inner_closure) = || {};
            // Mutate outer closure within inner scope
            *(&mut outer_closure) = || {};
        }
        // post-inner scope operations if necessary
    }
}

//# run --verbose 0x1::ClosureScopeTest::test_mutate_closure_in_scope
//# run --verbose 0x1::ClosureScopeTest::test_copy_move_closure_within_nested_scopes
//# run --verbose 0x1::ClosureScopeTest::test_closure_within_function_and_inner_scope

//# publish
module 0x2::ComputeClosureInteraction {
    fun compute_with_closure(p: u64): u64 {
        let mut p_local = p;
        // Create a move-only closure with drop constraint
        let mut closure: || has drop = || {
            // Closure captures and modifies local variable
            p_local = p_local + 1;
        };
        // Execute the closure
        closure();
        // Return expression involving updated p_local
        1 + (p_local + { p_local = p_local + 1; p_local})
    }
}

//# run 0x2::ComputeClosureInteraction::compute_with_closure --args 5