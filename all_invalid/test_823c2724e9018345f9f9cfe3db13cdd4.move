//# publish
module 0xabc::test_module {
    public fun return_variable(p: u64): u64 {
        // Assign the parameter to a local variable
        let result = p;
        // Return the local variable
        result
    }

    public fun swap_values(x: u64, y: u64): (u64, u64) {
        // Initialize swap counter
        let count = 3;
        // Loop to swap values multiple times
        while (count > 0) {
            let temp = x;
            x = y;
            y = temp;
            count = count - 1;
        };
        (x, y)
    }

    public fun nested_apply(): u64 {
        // Define a function that adds two numbers
        fun add(x: u64, y: u64): u64 {
            x + y
        }

        // Define a function that multiplies two numbers
        fun mul(x: u64, y: u64): u64 {
            x * y
        }

        // Apply nested functions: add(2, mul(3, 4))
        // Which computes add(2, 12) = 14
        apply(add, 2, apply(mul, 3, 4))
    }

    // Helper function to apply a binary function
    public inline fun apply(f: |u64, u64|u64, x: u64, y: u64): u64 {
        f(x, y)
    }
}

//# run 0xabc::test_module::return_variable --args 42
//# run 0xabc::test_module::swap_values --args 10 20
//# run 0xabc::test_module::nested_apply