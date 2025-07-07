
//# publish
module 0xBADD::ScopeAndVisibility {
    // Internal function only accessible within this module
    fun internal_increment(x: u64): u64 {
        x + 1
    }

    // Public entry function that uses internal functions and variable scopes
    public fun entry_point(initial: u64): u64 {
        let counter = initial;
        let i = 0;
        while (i < 3) {
            // Shadowing variable 'counter' inside the loop
            let counter = internal_increment(counter);
            counter // return the last shadowed value
            i = i + 1;
        };
        // Variable 'counter' outside the loop should hold the last value
        counter
    }

    // An internal helper that manipulates local variables
    fun shadow_test() {
        let x = 10;
        let y = 20;
        // Shadow x
        let x = y;
        // Shadow y
        let y = x;
        // Use the shadowed variables
        let _ = x;
        let _ = y;
    }
    // Public function to call internal shadow_test
    public fun call_shadow_test() {
        shadow_test()
    }

    // Attempt to call internal function from outside (should fail if uncommented in an actual test)
    // public fun external_call() {
    //     internal_increment(5)
    // }
}


//# run 0xBADD::ScopeAndVisibility::entry_point --args 5u64


//# run 0xBADD::ScopeAndVisibility::call_shadow_test


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
