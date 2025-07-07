
//# publish
module 0xDEAD::TestModule {
    // Basic function to test invocation with parameters
    public fun test_func(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    // Local variable assignment outside loops
    public fun outer_scope_test() {
        let a = 5u8;
        let b = 10u8;
        let result = 0u8;

        // Outer variable shadowing inside block
        if (a < b) {
            let a = b + 1; // shadowing outer 'a'
            let _ = a; // use shadowed a
        };

        // update outer result variable
        result = a + b; // assign to outer 'result'
        result
    }

    // While loop with local variables
    public fun while_loop_test(start: u8): u8 {
        let i = start;
        let total = 0u8;
        while (i < 10) {
            // define local inside loop
            total = total + i;
            i = i + 1;
        };
        total
    }

    // Nested loops with variable tracking
    public fun nested_loop_test() {
        let outer = 0u8;
        let outer_var = outer;
        while (outer_var < 3) {
            let inner_var = 0u8;
            while (inner_var < 2) {
                inner_var = inner_var + 1;
            };
            outer_var = outer_var + 1;
        };
        ()
    }

    // Internal function (should be accessible only within this module)
    fun internal_access_function(x: u8): u8 {
        x * 2
    }

    // Function to test access restriction
    public fun call_internal(x: u8): u8 {
        internal_access_function(x)
    }

    // Function with specification to verify purity (no effects)
    // Correct syntax in Move: 'has copy' should be in the function annotation
    public fun pure_function(x: u8): u8 {
        let y = x + 1;
        y
    } // 'has copy' not valid syntax in Move, remove it

    // Function with complex closure (curried like lambda)
    public fun curried_closure_test(flag: bool, a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 = |x: u8, y: u8| {
            if (flag) {
                x + y
            } else {
                x * y
            }
        };
        lambda(a, b)
    }
}



//# run 0xDEAD::TestModule::test_func --args 7u8 8u8



//# run 0xDEAD::TestModule::outer_scope_test



//# run 0xDEAD::TestModule::while_loop_test --args 3u8



//# run 0xDEAD::TestModule::nested_loop_test



//# run 0xDEAD::TestModule::call_internal --args 4u8



//# run 0xDEAD::TestModule::pure_function --args 9u8



//# run 0xDEAD::TestModule::curried_closure_test --args true 3u8 4u8



//# run 0xDEAD::TestModule::curried_closure_test --args false 3u8 4u8
