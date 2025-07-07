//# publish
module 0xC0FF::FeatureInteractionTest {
    use std::signer;
    use std::vector;

    // Internal struct, for encapsulation testing
    struct InternalStruct has copy, drop, store {
        a: u8,
        b: u8,
        c: bool,
    }

    // Public function that calls internal functions and manipulates variables
    public fun run_tests(s: signer) {
        // Call a private function within the module
        internal_helper(s);

        // Local variable assignment outside loops
        let mut_var = 1u8;
        let mut_var_shadow = 0u8;

        // Variable shadowing inside while loop
        let shadow_var = mut_var;
        while (shadow_var < 3u8) {
            let shadow_var = shadow_var + 1; // shadowing occurs here
            // shadow_var inside loop shadows outer
            // no deletion needed, just shadowing
        };

        // Verify that outer mut_var remains unchanged
        // Use a byte string to keep assertion simple
        let expected_value = 1u8;
        assert!(mut_var == expected_value, 101);

        // Destructuring a struct with named fields
        let s_struct = InternalStruct { a: 5, b: 10, c: true };
        let InternalStruct { a: a_field, b: b_field, c: c_field } = s_struct;
        assert!(a_field == 5, 102);
        assert!(b_field == 10, 102);
        assert!(c_field, 102);

        // Create an internal struct and verify access
        let internal_obj = InternalStruct { a: 2, b: 4, c: false };
        // Only this module can access internal struct structure
        verify_internal_struct(internal_obj);
    }

    // Internal helper function for encapsulation test
    fun internal_helper(s: signer) {
        // Do nothing, just testing internal scope
        let _ = s;
    }

    // Private function to verify internal struct integrity
    fun verify_internal_struct(obj: InternalStruct) {
        // Internal function, accessible only within module
        assert!(obj.a + obj.b == 9, 103);
        assert!(!obj.c, 103);
    }

    // Function to disassemble source into readable form - pseudo CC testing
    // (This is conceptual; in real tests, you'd invoke compiler tooling)
    public fun disassemble_code() {
        // No real disassembly in Move code, but we can simulate correctness checks
        // For testing purpose, it's a stub
    }

    // Function to test parse_identifier (simulated)
    public fun test_parse_identifier(code_snippet: vector<u8>): bool {
        // Basic simulation: verify code contains 'InternalStruct'
        let identifier_present = vector::contains(&code_snippet, b"InternalStruct");
        identifier_present
    }
}



//# run 0xC0FF::FeatureInteractionTest::run_tests --signers 0xABC0 --args 1u8

//# run 0xC0FF::FeatureInteractionTest::disassemble_code

//# run 0xC0FF::FeatureInteractionTest::test_parse_identifier --args b"module 0xC0FF::FeatureInteractionTest { struct InternalStruct { a: u8, b: u8, c: bool } }"
