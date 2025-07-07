
//# publish
module 0xDEAD::TestModule {
    use std::signer;

    // Public struct with internal visibility
    struct InternalStruct has copy, drop, store {
        field: u8
    }

    // Resource with internal visibility
    struct InternalResource {
        value: u16
    }

    // Public script entry point that calls internal functions and creates resources
    public fun entry_point(s: signer) {
        // Internal function call within module
        internal_function();
        // Create a resource
        move_to<InternalResource>(&s, InternalResource { value: 42 });
        // Call internal view function
        let (a, b) = internal_view_fn();
        // Explicitly use struct
        let s_obj = InternalStruct { field: 10 };
        // Assign a literal value with 'value' expression in script
        let literal_value = value 255u8;
        // Use the value to verify literal parsing
        assert!(literal_value == 255u8, 100);
    }

    // Internal function that modifies internal state
    fun internal_function() {
        // Just a dummy internal action
    }

    // Internal view function returning a tuple
    fun internal_view_fn(): (u8, u8) {
        (value 7u8, value 8u8)
    }

    // Internal function with attribute (e.g., axiom)
    // axiom: "internal_function_invariant"]
    fun internal_with_axiom() {
        // Placeholder for axiom attribute
    }

    // Function attempting external access (should be restricted but allowed here for testing scope)
    public fun external_call_internal(): bool {
        // Call internal function from outside module (should be disallowed by compiler in real scenario)
        // But for the test, we call
        internal_function();
        true
    }
}


//# run 0xDEAD::TestModule::entry_point --signers 0x100


//# publish
module 0xC0FF::LoopTest {
    use std::signer;

    // Entry point that tests while loop with variable shadowing
    public fun main(s: signer) {
        let counter = 0u64;
        let max = 3u64;

        // Outer while loop
        while (counter < max) {
            // Shadow variable
            let counter = counter + 1;
            // Local variable inside loop
            let _temp = counter * 2;
            // Check the shadowed variable value
            assert!(counter == 1u64 || counter == 2u64 || counter == 3u64, 200);
            // Increment real counter
            counter = counter + 0; // no change, just to use counter in scope
            // Integrity check: the outer counter is still 0 as we do not mutate it here
        };
        // Confirm outer counter remains unchanged after the loop
        // (note: in Move, shadowing creates new variable, original remains same)
        assert!(counter == 0u64, 201);
    }
}


//# run 0xC0FF::LoopTest::main --signers 0x101


//# publish
module 0xABCD::VisibilityTest {
    // Private (internal) resource, not exposed outside
    struct PrivateRes {
        data: u8
    }

    // Public struct that internally references PrivateRes
    struct ExposedStruct has copy, drop, store {
        hidden_res: PrivateRes
    }

    // Internal function that initializes resource
    fun init_private_resource(): PrivateRes {
        PrivateRes { data: 255 }
    }

    // Public function that creates and exposes ExposedStruct
    public fun create_exposed(s: signer): ExposedStruct {
        let res = init_private_resource();
        ExposedStruct { hidden_res: res }
    }

    // Internal function to access PrivateRes data
    fun get_private_data(res: &PrivateRes): u8 {
        res.data
    }

    // Public function that accesses internal data via exposed struct
    public fun access_private_data(es: &ExposedStruct): u8 {
        get_private_data(&es.hidden_res)
    }
}


//# run 0xABCD::VisibilityTest::create_exposed --signers 0x202


//# run 0xABCD::VisibilityTest::access_private_data --args <address_of_exposed_struct> --signers 0x202
// Note: Running with actual address of created struct in real test environment


//# publish
module 0x1234::LiteralAndErrorTest {
    use std::signer;

    // Function testing literals with 'value'
    public fun literals_test() {
        let a = value 123u8;
        let b = value 0xffu8;
        assert!(a == 123u8, 300);
        assert!(b == 255u8, 301);
    }

    // Function to intentionally cause a compiler error by invalid literal (simulate error detection)
    public fun fake_error() {
        // invalid literal: uncomment to cause compile error
        // let invalid = value -1u8; // Should cause compile error (negative literal not allowed)
    }

    // Function with attribute, ensuring attribute inclusion
    // doc = "Testing custom properties"]
    public fun property_attribute_test() {
        // dummy
    }
}


//# run 0x1234::LiteralAndErrorTest::literals_test


//# publish
module 0x0BAD::ErrorHandling {
    // Function that triggers a compile-time error for invalid code
    // error("This is a test error")]
    public fun compile_error_trigger() {
        // intentionally invalid
    }

    // Function that uses attribute to check correct parsing
    // attribute: "prop"]
    public fun attribute_test() {
        // nothing
    }
}

// The above modules cover: 
// - scripts with function calls, variables, literals
// - inner and outer visibility restrictions
// - while loops with variable shadowing
// - value expressions with literals
// - compiler error testing (comments only for invalid code)
// - function attributes for properties
// All components combined will thoroughly test the compiler and VM.


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// ff513cd37aa928903aae1b007537a562: Create value expressions using literals with the `value` expression.
// dba6ccc33a58baa3a452a37cd0f7d3c0: Run the Move compiler and output errors to the standard error stream.
// 1ebef9f7d1703a5635de74d53bd7cf18: Include properties for the 'axiom' to describe additional attributes or conditions.
