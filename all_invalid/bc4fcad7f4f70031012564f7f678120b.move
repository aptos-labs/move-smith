
//# publish
module 0xCAFE::TestModule {
    // Internal functions for access control testing
    fun internal_func(): u8 {
        42
    }

    // Public function to call internal function within the same module
    public fun call_internal_func(): u8 {
        internal_func()
    }

    // A recursive inline function to simulate cyclic call pattern, with a depth parameter
    public inline fun inline_recursive(n: u8): u8 {
        if (n == 0) {
            1
        } else {
            // recursive call
            inline_recursive(n - 1) + 1
        }
    }
}


//# run 0xCAFE::TestModule::call_internal_func --args 


//# run 0xCAFE::TestModule::inline_recursive --args 5u8


//# publish
module 0xCAFE::VariableScopeTest {
    use std::assert;
    
    // Function to test variable scoping with while loops and shadowing
    public fun variable_scope_test() {
        let outer_var = 10;
        let inner_var = 20;

        let counter = 0;
        while (counter < 3) {
            // Shadowing outer_var within the loop
            let outer_var = outer_var + 1;
            // Shadowing inner_var
            let inner_var = inner_var + 1;

            // Access the shadowed variables
            assert!(outer_var == 11 + counter, 1);
            assert!(inner_var == 21 + counter, 1);
            counter = counter + 1;
        };
        // After loop, verify original variables remain unchanged
        assert!(outer_var == 10, 2);
        assert!(inner_var == 20, 2);
    }
}


//# run 0xCAFE::VariableScopeTest::variable_scope_test


//# publish
module 0xCAFE::LoopControlFlow {
    use std::assert;

    public fun loop_and_break_test(): u8 {
        let sum = 0;
        let i = 0;

        while (i < 10) {
            if (i == 5) {
                break;
            };
            sum = sum + i;
            i = i + 1;
        };
        // test break
        assert!(i == 5, 3);
        // continue similar pattern with while
        let j = 0;
        while (j < 10) {
            if (j == 3) {
                j = j + 1;
                continue;
            };
            sum = sum + j;
            j = j + 1;
        };
        sum
    }

    // Function to test nested loop with label (assumed), simulate with flags
    public fun nested_loop_test(): u8 {
        let x = 0;
        let y = 0;

        'outer: loop {
            if (x >= 3) {
                break;
            };
            y = 0;
            'inner: loop {
                if (y >= 3) {
                    break;
                };
                if (x == 1 && y == 1) {
                    y = y + 1;
                    continue;
                };
                x = x + y;
                y = y + 1;
            };
            x = x + 1;
        };
        x
    }
}


//# run 0xCAFE::LoopControlFlow::loop_and_break_test

//# run 0xCAFE::LoopControlFlow::nested_loop_test


//# publish
module 0xCAFE::InlineCycleCheck {
    use std::assert;

    // This function attempts to inline a cyclic call pattern
    public inline fun cycle_function(): u8 {
        // Try to call itself, but since inlining cycles are prevented, this should fail
        // We simulate an inline cycle warning or check indirectly by recursion depth
        0
    }

    // A wrapper public to test inlining in const context
    public fun test_inline_cycle() {
        // Call inline_recursive with depth 3 to test inline mechanism
        let res1 = 0xCAFE::TestModule::inline_recursive(3);
        assert!(res1 == 4, 4);
    }
}


//# run 0xCAFE::InlineCycleCheck::test_inline_cycle


//# publish
module 0xCAFE::InteractionTest {

    use 0xCAFE::MyModule;

    public fun layered_call() {
        let _ = MyModule::f1(255u8, false);
        let _ = MyModule::f3(65535u16);
        let _ = MyModule::f4();
        let _ = MyModule::f5();
        let _ = MyModule::f6(|x: u8| x + 10, 7u8);
        let _ = MyModule::f7();
        let _ = MyModule::f8();
    }

    // Call inspection to test access restriction
    public fun call_internal() {
        // Should succeed within the same module
        let v = MyModule::call_internal_func();
        assert!(v == 42, 5);
    }
}


//# run 0xCAFE::InteractionTest::layered_call

//# run 0xCAFE::InteractionTest::call_internal


// Featurres:
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 849cdc3430d3537a79447731cdcfa751: Detect and prevent cyclic calls between inline functions to avoid infinite inlining.
