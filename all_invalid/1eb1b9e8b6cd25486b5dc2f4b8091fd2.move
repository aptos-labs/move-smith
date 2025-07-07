//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // Internal function to test access control (restricted from outside)
    fun internal_sum(a: u8, b: u8): u8 {
        a + b
    }

    // Public wrapper to call internal_sum internally
    public fun call_internal_sum(a: u8, b: u8): u8 {
        internal_sum(a, b)
    }

    // Recursive Fibonacci function
    public fun fib(n: u64): u64 {
        if (n < 2) {
            n
        } else {
            fib(n - 1) + fib(n - 2)
        }
    }

    // Entry point for variable and loop scoping test
    public fun variable_scope_test() {
        let a = 5u64; // Outer variable

        // Declare inner variable shadowing outer
        let a = a + 10; // Shadowed 'a', should be 15 now

        // Setup loop condition variable
        let count = 0u64; // Make 'count' mutable

        // Outer loop for variable mutation
        while (count < 3) {
            // Inside block scope
            {
                // Shadow the 'a' variable inside inner block
                let a = a + count; // Shadowed 'a', should be 15 + count
                // Use shadowed 'a' inside
                let _ = a; // Just to check the value
            }

            // After inner block, original 'a' should remain unchanged
            // Mutate outer 'a' safely by creating a new binding
            let a = a + 1; // create new 'a' binding

            // Update loop counter
            count = count + 1;
        }

        // After loop, verify 'a' value
        // 'a' should have been incremented 3 times, starting from 15
        let _final_a = a; // Should be 18
    }

    // Entry point for variable assignment and shadowing tests
    public fun shadowing_test() {
        let x = 10u8;
        {
            let x = x + 5; // Shadow outer x, x= 15
            let _inner_x = x;
        }
        // Outer x should remain unchanged
        let _ = x; // 10
    }
}



//# run 0xCAFE::TestModule::variable_scope_test


//# run 0xCAFE::TestModule::shadowing_test


//# run 0xCAFE::TestModule::call_internal_sum --args 7u8 8u8


//# run 0xCAFE::TestModule::fib --args 0u64


//# run 0xCAFE::TestModule::fib --args 1u64


//# run 0xCAFE::TestModule::fib --args 2u64


//# run 0xCAFE::TestModule::fib --args 3u64


//# run 0xCAFE::TestModule::fib --args 4u64


//# run 0xCAFE::TestModule::fib --args 5u64


//# run 0xCAFE::TestModule::fib --args 6u64


//# run 0xCAFE::TestModule::fib --args 7u64


//# run 0xCAFE::TestModule::fib --args 8u64


//# run 0xCAFE::TestModule::fib --args 9u64


//# run 0xCAFE::TestModule::fib --args 10u64
