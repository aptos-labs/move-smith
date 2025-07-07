//# publish
module 0xc0ffee::m {
    // Define a constant for abort code testing
    const ERROR_CODE: u64 = 42;

    // A resource that has the 'has' ability for types
    struct AbilityHolder has key {
        value: u64,
    }

    // Function to add two u64 values
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    // Function to test ability constraint - accepts any type with 'has drop'
    public fun test_ability<T: has(drop)>(x: T): bool {
        // Dummy function to ensure 'has' ability is used
        // No runtime effect
        true
    }

    // The main test function that performs various arithmetic operations and checks
    public fun test(): u64 acquires AbilityHolder {
        let x = 10;
        let y = 20;

        // Compute sum
        let sum = add(x, y); // 30

        // Compute product
        let prod = add(sum, sum); // 60 (simulate as sum + sum)

        // Perform some operations
        let result1 = add(sum, prod); // 30 + 60 = 90
        let result2 = add(result1, 10); // 100

        // Use ability constraint function
        // For demonstration, create a dummy value
        let holder = AbilityHolder { value: 100 };
        test_ability<AbilityHolder>(&holder);

        // Return final result
        result2
    }

    // Runner function for module testing
    public fun run_tests(): () {
        // Call the test function
        test();
    }
}

//# run 0xc0ffee::m::run_tests