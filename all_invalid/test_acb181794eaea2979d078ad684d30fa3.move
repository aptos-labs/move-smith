//# publish
module 0xabc::test_module {
    // Function to demonstrate nested inline function calls and variable passing
    inline fun outer_func(a: u64, b: u64): u64 {
        a + b
    }

    public fun call_outer(): u64 {
        // Inline function calling another inline function
        fun inner_func(x: u64, y: u64): u64 {
            // Closure that multiplies its argument by 2
            let double = |val: u64| val * 2;
            let sum = outer_func(x, y);
            double(sum)
        }
        inner_func(5, 10)
    }

    // Function to test tuple destructuring with nested inline functions
    public fun tuple_test(): u64 {
        let (a, b) = (3u64, 4u64);
        // Inline function that takes a tuple and sums the elements
        inline fun sum_tuple(t: (u64, u64)): u64 {
            let (x, y) = t;
            x + y
        }
        sum_tuple((a, b))
    }

    // Function utilizing closure with parameters and inline functions
    public fun closure_and_inline(): u64 {
        let multiplier = |x: u64| x * 3;
        // Inline function that accepts a closure
        inline fun process(val: u64, f: |u64|u64): u64 {
            f(val)
        }
        process(7, |x| multiplier(x))
    }

    // Function to test variable shadowing and reassignment behavior
    public fun shadowing_test(): u64 {
        let x = 2u64;
        let x = x + 3; // Shadowing previous x
        // This should be a new variable x
        let y = x * 2;
        y
    }

    // Function to test nested inline functions with parameters, tuples, and closures
    public fun complex_nested(): u64 {
        inline fun level1(a: u64): u64 {
            inline fun level2(b: u64): u64 {
                let f = |x: u64| x + a + b;
                f(b)
            }
            level2(a)
        }
        level1(5)
    }

    // Function to test attempt to reassign immutable variable (should be compile-time error)
    // Note: Not called, just for demonstration
    public fun reassignment_attempt(): u64 {
        let z = 10;
        // The following line should cause a compile error in Move
        // z = z + 1;
        z
    }
}

// //# run 0xabc::test_module::call_outer

// //# run 0xabc::test_module::tuple_test

// //# run 0xabc::test_module::closure_and_inline

// //# run 0xabc::test_module::shadowing_test

// //# run 0xabc::test_module::complex_nested

// //# run 0xabc::test_module::reassignment_attempt