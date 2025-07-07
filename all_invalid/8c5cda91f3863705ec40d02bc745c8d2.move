
//# publish
module 0xCAFE::TestModule {
    // Use standard library for vector and assertions
    use std::vector;
    use std::assert;

    // Define an enum with nested structures for pattern matching
    enum NestedEnum has copy, drop {
        VariantA,
        VariantB { inner_value: u8 },
        VariantC { nested: VariantB },
    }

    // Function that creates nested control flow with nested if-continue inside a loop
    public fun nested_control_flow_test() {
        let i: u8 = 0;
        loop {
            if (i >= 5) {
                break;
            };
            if (i % 2 == 0) {
                i = i + 1;
                continue;
            };
            // Here, i is odd
            if (i == 3) {
                i = i + 2;
                // Skip the rest
                continue;
            };
            i = i + 1;
        };
        // The final value of i should be 5
    }

    // Function to extract u8 field from enum variants with nested structures
    public fun extract_inner_value(v: NestedEnum): u8 {
        match (v) {
            NestedEnum::VariantA => 0,
            NestedEnum::VariantB { inner_value } => inner_value,
            NestedEnum::VariantC { nested } => {
                match (nested) {
                    NestedEnum::VariantB { inner_value } => inner_value,
                    _ => 255,
                }
            }
        }
    }

    // Inline function that calls a public function respecting visibility
    public inline fun call_public_function(): u8 {
        public_function()
    }

    // A public function to be called
    public fun public_function(): u8 {
        42
    }

    // Function to verify that a module binary has correct header / magic number
    public fun validate_binary_header(binary_data: vector<u8>): bool {
        // Expected header: [0x0A, 0x0B, 0x0C, 0x0D]
        let header: vector<u8> = vector[b"\\x0A", "\\x0B", "\\x0C", "\\x0D"];
        let is_valid = vector::equals(&binary_data[0..4], &header);
        is_valid
    }

    // Function to test non-cyclic recursive call chain
    public fun chain_call(count: u64): u64 {
        if (count == 0) {
            0
        } else {
            chain_call(count - 1) + 1
        }
    }

    // Modules with hierarchy to test nested access
//# publish
    module 0xCAFE::SubModule {
        public fun get_value_from_sub(): u8 {
            7
        }
    }

    // Function to access nested module component
    public fun access_nested_module(): u8 {
        0xCAFE::SubModule::get_value_from_sub()
    }
}


//# run 0xCAFE::TestModule::nested_control_flow_test

//# run 0xCAFE::TestModule::extract_inner_value --args 0 // VariantA

//# run 0xCAFE::TestModule::extract_inner_value --args 1 // VariantB { inner_value: 1 }

//# run 0xCAFE::TestModule::extract_inner_value --args 2 // VariantC { nested: VariantB { inner_value: 2 } }

//# run 0xCAFE::TestModule::call_public_function

//# run 0xCAFE::TestModule::validate_binary_header --args 0x0A0B0C0D // Correct header

//# run 0xCAFE::TestModule::validate_binary_header --args 0xFFFF0000 // Incorrect header

//# run 0xCAFE::TestModule::chain_call --args 10

//# run 0xCAFE::TestModule::access_nested_module


// Featurres:
// 312e4630fd94dea2ace81bdc0229c624: Test that nested if-continue statements correctly interact with an outer loop, allowing the loop to break when the condition is false.
// cc7335a7d0ed25948a3f0fdc50f7e55a: Test that functions can correctly extract specific u8 fields from enum variants with nested structures.
// 7cc4440f5a0fcc67cf1f70523cd9069a: Call other functions from inline functions, respecting their visibility constraints.
// e7b077bea943e18adb846b12ace19b8c: Validate the binary structure of compiled Move modules using standard magic numbers
// 800f1506e1b2392621616a643d3141bb: Use inline functions without creating cyclic recursion chains.
// a5648524b7f4c78c5d3827c1b2057d23: Use prefixes or path segments to access nested components or modules in Move code.
