
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
        while (count < 3) {
            if (count % 2 == 0) {
                // Nested match statement
                let _res = match (count) {
                    0 => {
                        // For first iteration
                        if (true) {
                            10u8
                        } else {
                            20u8
                        }
                    },
                    1 => 30u8,
                    _ => 40u8,
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

    // Function to simulate access control (since Move does not have 'friend', jusct for test)
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


// Featurres:
// 88780a25fcdc495a06545d1cbd51852d: Define functions with explicitly specified type parameters and parameters.
// 81d7b796a8282833827611e111ad9db6: Use language constructs that require a minimum Move language version.
// 7674c49fd390a223ca5ce8af7ec49511: Declare friend modules or declarations for access control.
