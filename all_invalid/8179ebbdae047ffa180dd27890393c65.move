
//# publish
module 0xDEAD::FeatureInteractionTest {
    use std::vector;
    use 0xDEAD::AliasModule as Alias;

    const MODULE_ID: u32 = 0xC0FFEE;

    struct Config has copy, drop, store {
        name: vector<u8>,
        value: u64,
    }

    // Function that accepts parameters and creates a closure capturing these parameters and struct fields
    public fun create_and_invoke_closure(
        s: Config,
        id: u32,
        message: vector<u8>
    ) {
        // Capture the parameters and struct fields in the closure
        let closure = |param: u64| -> u64 {
            // Accessing the captured variables
            let sum = s.value + id as u64 + param + (if (vector::length(&message) > 0) { 1 } else { 0 }) as u64;
            // Using module references via original name and alias
            let _id_copy = MODULE_ID;
            let _alias_value = Alias::get_constant();

            // Confirm usage of the message vector (simulate some operation)
            let msg_length = vector::length(&message);
            // Return the sum to verify closure's access
            sum + msg_length as u64
        };

        // Invoke the closure with a test argument
        let result = closure(42);
        // The result can be used for assertions if needed
        // But as per instruction, no assertions needed
    }

    // Additional function in module, to be run
    public fun runner() {
        let config = Config {
            name: b"TestConfig",
            value: 1234,
        };
        let id = 567u32;
        let message = b"hello world";
        create_and_invoke_closure(config, id, message);
    }

    // Constants, enums, or types used in the test to verify referencing
    public fun get_constant(): u64 {
        999
    }
}

// Alias module for testing alias usage

//# publish
module 0xDEAD::AliasModule {
    // Simple function to verify alias references
    public fun get_constant(): u64 {
        555
    }
}


//# run 0xDEAD::FeatureInteractionTest::runner


// Featurres:
// da47049de87ec5a54f5462a7052a8e62: Test that closures in Move can capture variables, including function parameters and fields from captured structs, and use them correctly during invocation.
// 6b60b8cce86c81a60a70451508709146: Reference named modules, types, or values by identifiers in your Move code
// 4eb107ba5a9492acc1b83057f46cd48a: Use 'as' to create an alias in a 'use' statement.
