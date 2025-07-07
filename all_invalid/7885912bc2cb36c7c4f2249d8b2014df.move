//# publish
module 0xDEADBEEF::TypeParamAndFriendTest {
    // You NEVER try to use this 0xDEADBEEF::TypeParamAndFriendTest
    // It is only an example

    /// Struct with explicit type parameter
    struct Container<T> has drop, store {
        value: T,
    }

    /// Friend module declaration for access control
    public fun add_friend_authority() {
        // This is just a placeholder to simulate friend declaration concept
        // Move currently doesn't have explicit friend modules, but hypothetical feature
        // For testing, we can simulate access restrictions elsewhere
    }

    // Function with explicit type parameters and parameters
    public fun instantiate_container<T: copy + drop + store>(val: T): Container<T> {
        Container { value: val }
    }

    // Function utilizing language constructs that require minimal Move version (e.g., nested loops, match, fallthrough)
    public fun complex_control_flow<T: copy + drop + store>(container: &Container<T>) {
        let count = 0;
        while (count < 3) /* Move supports while loops with this syntax */ {
            if (count % 2 == 0) {
                // Corrected match syntax: no 'match' statement in Move, but 'switch' is not supported
                // Instead, use if-else chains or pattern matching via if-else
                // To mimic match, use if-else chains

                // For the purpose of this test, simulate match with if-else
                let _res = if (count == 0) {
                    true
                } else {
                    false
                };
                // Since the original uses match to assign numbers, emulate with if-else
                let value = if (count == 0) {
                    10u8
                } else {
                    if (count == 1) {
                        30u8
                    } else {
                        40u8
                    }
                };
            } else {
                // Do nothing
            };
            count = count + 1;
        };
        // Use container reference
        let _val = &container.value;
    }

    // Function demonstrating explicit language features and control flow
    public fun control_flow_demo<T: copy + drop + store>(val: T): T {
        // Create a container with type parameter T
        let container = instantiate_container<T>(val);
        // Use complex control flow
        complex_control_flow<&T>(&container);
        // Return the original value (simulate some transformation)
        val
    }

    // Function to simulate access control (since Move does not have 'friend', just for test)
    public fun access_container_value<T: copy + drop + store>(container: &Container<T>): T {
        // Access internal value
        container.value
    }

    // Runner function to test the above
    public fun run_test() {
        let c1 = instantiate_container<u8>(42);
        let v = access_container_value<&u8>(&c1);
        control_flow_demo<u8>(v);
    }
}



//# run 0xDEADBEEF::TypeParamAndFriendTest::run_test
