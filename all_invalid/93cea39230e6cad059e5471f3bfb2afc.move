
//# publish
module 0xDEAD::FeatureTest {
    use std::assert;
    use std::signer;

    // Global variable simulated via resource in storage
    struct Counter has key {
        value: u64,
    }

    public fun initialize_counter(s: signer) {
        move_to<Counter>(&s, Counter { value: 0 });
    }

    // Function with local variables inside while loop, testing variable scope and shadowing
    public fun loop_variable_scope(iter_count: u64): u64 {
        let total = 0;
        let i = 0;
        while (i < iter_count) {
            // Shadow i
            let i = i + 1; // Shadowed i inside loop
            total = total + i;
            i = i; // Does not compile, so we avoid redeclaration, simulate shadowing via separate scope
            // simulate shadow with block scope
            {
                let i_shadow = i + 10; // new variable shadowing outer i
                total = total + i_shadow;
            }
            // After inner block, original i remains
            i = i + 1;
        };
        total
    }

    // Function to test local variable inside if statement
    public fun if_variable_test(flag: bool): u64 {
        let sum = 0;
        if (flag) {
            let temp = 42;
            sum = sum + temp;
        } else {
            let temp = 24;
            sum = sum + temp;
        };
        sum
    }

    // Function with internal (private) functions
    fun internal_add(x: u64, y: u64): u64 {
        x + y
    }

    public fun call_internal_add(x: u64, y: u64): u64 {
        internal_add(x, y)
    }

    // Attempt to call internal directly from outside should fail (simulate test)
    // Not coded here; in the test, an external attempt should not compile

    // Spec variables
    spec module {
        var global_counter: u64;

        // Global variable annotation
        property global_counter {
            exists self.global_counter;
        }
    }

    // bind expression with complex expression simulation
    public fun complex_bind_test(x: u64, y: u64): u64 {
        let sum = (x + y)
            + (x * y);
        sum
    }

    // Script to test execution
//# run
    script {
        use 0xDEAD::FeatureTest;

        fun main(s: signer) {
            // Initialize global counter
            FeatureTest::initialize_counter(&s);
            
            // Test loop variable scope and shadowing
            let total1 = FeatureTest::loop_variable_scope(5);
            // Test if variable shadowing passed
            let total2 = FeatureTest::if_variable_test(true);
            let total3 = FeatureTest::call_internal_add(10, 20);
            // Test bind with complex expression
            let total4 = FeatureTest::complex_bind_test(3, 4);
            // Verify counter resource exists
            let counter_ref: &Counter = borrow_global<Counter>(signer::address_of(&s));
            assert!(counter_ref.value == 0, 1000);
            // Modifying global via updating resource
            // Not performed here; focus on read
            // End of script
            (total1, total2, total3, total4)
        }
    }
}

 
//# run 0xDEAD::FeatureTest::main --signers 0xBADD --args


// Featurres:
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// caa4ab8a3e36141117c8c50d0a12748d: Specify global or local variables in specifications.
// b97f161fc46919e92f4e2b88ea9444ff: Bind variables to the result of expressions
// 82f755af6a64ca1b7520a8282c6064dc: Define scripts using the 'script' keyword in Move files.
// fd4b1b73077e99bf22a55a18ee5a78fa: Declare 'use' statements in modules to import members from other modules.
