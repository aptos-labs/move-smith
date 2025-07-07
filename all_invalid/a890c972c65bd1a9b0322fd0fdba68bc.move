
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
            // Shadow i: since Move doesn't support variable shadowing, simulate with inner block scope or reuse variable
            // For clarity, reuse variable i
            i = i + 1; // Increment i
            total = total + i;
            // simulate shadow with block scope
            {
                let i_shadow = i + 10; // new variable shadowing outer i
                total = total + i_shadow;
            }
            // After inner block, i remains
            // Additional increment if needed
            // i = i; // No change
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
        }; // semicolon here to end if-else block
        sum
    }

    // Function with internal (private) functions
    fun internal_add(x: u64, y: u64): u64 {
        x + y
    }

    public fun call_internal_add(x: u64, y: u64): u64 {
        internal_add(x, y)
    }

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
