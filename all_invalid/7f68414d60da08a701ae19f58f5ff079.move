
//# publish
module 0xDEAD::TestInteraction {
    use std::signer;
    use std::vector;

    // Create a struct with multiple fields and various types
    struct MultiFieldStruct has copy, drop, store, key {
        id: u64,
        label: vector<u8>,
        active: bool,
        count: u32,
    }

    // Internal function with restricted access
    fun internal_helper(x: u64): u64 acquires Self {
        x + 42
    }

    // Public function that calls internal helper, to test access restrictions
    public fun call_internal(x: u64): u64 {
        internal_helper(x)
    }

    // Specification for a struct: enforce some constraints
    struct SpecResource has key {
        // dummy constraint: 'value' must be less than 100
        value: u8,
    }

    // Module collectively deprecated at address-level
    
//# deprecated
//# publish
    module 0xBADD::DeprecatedModule {
        public fun deprecated_func(): u8 {
            42
        }
    }

    // Another module with nested '>>' tokens in comments (simulate parser handling)
//# publish
    module 0xC0DE::NestedTokens {
        // Testing nested '>>' tokens within documentation or comments
        // Example: <<< some complex syntax with >> tokens >>>
        public fun dummy(): u8 { 1 }
    }

    // Inline function to be embedded
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    // Non-inline function
    public fun non_inline_mult(a: u8, b: u8): u8 {
        a * b
    }

    // Function to test parser with nested '>>' tokens
    public fun process_nested_tokens(): u8 {
        // Dummy logic, just return 1
        1
    }

    // Function to test validator constraints
    public fun check_spec_value(x: u8): bool {
        let resource = move_to_resource<SpecResource>(signer::address_of(&signer::specify_address()));

        if (x < resource.value) {
            true
        } else {
            false
        }
    }

    // Helper to simulate signer address for resource creation
    public fun specify_address(): signer {
        // Using a fixed signer for testing
        signer::specify_address()
    }

    // Function to instantiate and manipulate 'MultiFieldStruct'
    public fun create_and_modify_struct(id: u64, label: vector<u8>, active: bool, count: u32): MultiFieldStruct {
        let s = MultiFieldStruct { id, label, active, count };
        // Modify fields inside
        s
    }

    // Wrapper to invoke deprecated module function, should fail if deprecated
    public fun call_deprecated(): u8 {
        0xBADD::DeprecatedModule::deprecated_func()
    }
}


//# run 0xDEAD::TestInteraction::call_internal --args 100u64

//# run 0xDEAD::TestInteraction::create_and_modify_struct --args 12345u64 b"label" true 10u32


//# run 0xDEAD::TestInteraction::process_nested_tokens


//# run 0xDEAD::TestInteraction::check_spec_value --args 50u8


//# run 0xDEAD::TestInteraction::create_and_modify_struct --args 54321u64 b"another" false 0


//# run 0xDEAD::TestInteraction::call_deprecated --signers 0xBADD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 5d06b27b54b8c9fe107c4b6c915e1ac6: Use the '<' token as an end delimiter in parsing contexts where nested '>>' tokens are involved.
// 296137f73b01ca107f2e516f6e55c58b: Use function inlining and control whether to keep or lift inline functions
// 107f519cdb04a9583c77986ee754dd01: Define struct fields with types, and ensure each field has a unique name within the struct definition.
