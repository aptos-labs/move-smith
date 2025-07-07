
//# publish
module 0xBADA::TestVariableShadowing {
    use std::vector;

    struct Counter has store, key {
        count: u64,
    }

    public fun create_counter(): Counter {
        Counter { count: 0 }
    }

    // Inline function that accepts a closure and executes it
    // This simulates testing variable shadowing within closure
    public fun execute_closure(f: |mut u64|): u64 {
        let res = 0;
        f(&mut res);
        res
    }

    // Test function for variable shadowing
    public fun shadowing_test(counter: &mut Counter): u64 {
        // Shadow existing variable 'c' with new 'c' inside closure
        let c = &mut counter.count;

        // Define a closure that modifies c
        let closure = |x: &mut u64| {
            let _ = *x + 10;
            *x = *x + 1; // Increment the shadowed variable
        };

        // Call execute_closure with the closure, which should modify counter.count
        let _ = execute_closure(closure);

        // Return the updated counter
        *c
    }

    public fun test_run() {
        let cnt = create_counter();
        let cnt_ref = &mut cnt;
        let updated_value = shadowing_test(&mut cnt_ref);
        // This function is a runner, no assertion, just for compiler/VM execution
        // The final value of cnt.count should be initial + 1
        updated_value
    }
}


//# run 0xBADA::TestVariableShadowing::test_run


// Featurres:
// 72e43dbfdcd5686981b2a69d3b4b0ed1: Name local variables using ASCII lowercase letters ('a'..'z') or an underscore ('_') as the first character.
// e878ceaaa18ef0901ef97bec32f14943: Use the 'use' statement to import a module or member by its name.
// 74ac9c50dd657ff88b2f637c4d0aedf9: Test that the Move compiler correctly implements variable renaming (shadowing) within closures passed to inline functions, ensuring that assignments inside closures to outer variables actually update the intended variable.
