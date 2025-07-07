
//# publish
module 0xCAFE::TestInteraction {
    use std::option;

    // Internal function, should be inaccessible outside this module
    fun internal_hidden_function(): u8 {
        42
    }

    // Public script entry point that interacts with loops, variables, and internal functions
    public script {} {
        let x: u64 = 0;
        let y: u64 = 10;

        // Outer loop to test variable retention and shadowing
        while (x < y) {
            // Shadow the variable x inside the nested scope
            let x: u64 = x + 1;
            // Call internal function
            let _ = internal_hidden_function();
            // Increment outer x
            x = x + 1;
        };

        // Variable y remains unchanged
        // Final value of x should be y if the loop runs until x == y
        // For the test, no assertions needed, just execution
    }

    // Function to test access restriction (should not be callable externally)
    public fun call_internal_hidden(): u8 {
        internal_hidden_function()
    }

    // Struct with options
    struct OptionalData has store, key {
        optional_field: option::Option<u64>,
        mandatory_field: u64,
    }

    public fun init_with_optional(x: u64): OptionalData acquires OptionalData {
        let opt: option::Option<u64> = if (x % 2 == 0) {
            option::some(x)
        } else {
            option::none()
        };
        let s = OptionalData {
            optional_field: opt,
            mandatory_field: x,
        };
        s
    }

    // Source map serialization function (dummy implementation)
    public fun generate_source_map() {
        let source_code = "
//# publish
            module 0xCAFE::TestInteraction {
                // ...
            }
        ";
        // Dummy source map data: line number to code snippet
        let source_map = vector([
            (1u8, "module 0xCAFE::TestInteraction {"),
            (2u8, "    use std::option;"),
            (3u8, "    fun internal_hidden_function(): u8 {"),
            (4u8, "        42"),
            (5u8, "    }"),
            (6u8, "    public script {} {"),
            (7u8, "        let x: u64 = 0;"),
            (8u8, "        while (x < y) {"),
            (9u8, "            let x: u64 = x + 1;"),
            (10u8, "            let _ = internal_hidden_function();"),
            (11u8, "        };"),
            (12u8, "    }"),
            (13u8, "}")
        ]);
        // Serialize source map as a vector of tuples, in real use would be JSON
        let _ser = bcs::to_bytes(&source_map);
    }
}


//# run 0xCAFE::TestInteraction::generate_source_map


//# run 0xCAFE::TestInteraction::init_with_optional --args 4u64


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 5f1b6ce5fd8d403c37036be57af723e0: Declare structs with optional attributes in your Move modules.
// 0425835c5696d42eaaf7333cc1c87345: Serialize source maps when requested, associating source code with compiled units.
