
//# publish
module 0xCAFE::BehaviorTest {
    use std::assert;

    // Define a public struct with a constructor
    struct Counter has copy, drop, store {
        value: u64,
    }

    // Constructor function
    public fun new_counter(init_value: u64): Counter {
        Counter { value: init_value }
    }

    // Method to increment the counter
    public fun increment(c: &mut Counter) {
        c.value = c.value + 1;
    }

    // Method to get the current value
    public fun get_value(c: &Counter): u64 {
        c.value
    }

    // Define a struct with private field, only accessible via functions
    struct PrivateData has copy, drop, store {
        secret: u8,
    }

    // Constructor for PrivateData
    public fun create_private(secret: u8): PrivateData {
        PrivateData { secret }
    }

    // Public function to reveal secret, testing access modifiers
    public fun reveal_secret(p: &PrivateData): u8 {
        p.secret
    }

    // Function with specifications (for demo purpose - no native spec syntax here, so a comment)
    // [Behavior: This function adds two u8 values with detailed behavior]
    public fun add_with_behavior(a: u8, b: u8): u8 {
        a + b
    }

    // Function that constructs a struct with nested constructor syntax 
    public fun create_structs(): (Counter, PrivateData) {
        let c = new_counter(10);
        let p = create_private(5);
        (c, p)
    }

    // Function demonstrating various access modifiers and behaviors
    public fun test_behavior() {
        // Create a new counter with initial value 0
        let counter = new_counter(0);
        // Increment the counter
        increment(&mut counter);
        // Check the value after increment
        let val = get_value(&counter);
        // Assert expected behavior
        assert!(val == 1, 999);

        // Create private data
        let private = create_private(42);
        // Reveal secret
        let secret_value = reveal_secret(&private);
        assert!(secret_value == 42, 998);

        // Construct nested structs
        let (counter2, private2) = create_structs();

        // Test the constructor-created structs
        assert!(get_value(&counter2) == 10, 997);
        let secret2 = reveal_secret(&private2);
        assert!(secret2 == 5, 996);
    }
}


//# run 0xCAFE::BehaviorTest::test_behavior