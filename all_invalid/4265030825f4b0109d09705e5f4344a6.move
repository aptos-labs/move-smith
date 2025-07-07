
//# publish
module 0xCAFE::TestInteraction {
    use std::signer;
    use 0xCAFE::MyModule;

    // Public function with various parameter types for signature string generation
    public fun param_signature_generator(a: u8, b: u16, c: u32, d: bool): vector<u8> {
        let sig = vector::empty<u8>();
        vector::push_back(&mut sig, b"u8"[0]);
        vector::push_back(&mut sig, b" " [0]);
        let a_str = b"u8";
        vector::append(&mut sig, a_str);
        vector::push_back(&mut sig, b',');

        vector::push_back(&mut sig, b" u16"[0]);
        vector::push_back(&mut sig, b',');

        vector::push_back(&mut sig, b" u32"[0]);
        vector::push_back(&mut sig, b',');

        vector::push_back(&mut sig, b" bool"[0]);

        sig
    }

    // Function to generate value expressions with constants
    public fun generate_value_exprs() {
        let val_u8 = 255u8;
        let val_u16 = 65535u16;
        let val_u32 = 4294967295u32;
        let val_bool = true;

        let call_sig = param_signature_generator(
            val_u8,
            val_u16,
            val_u32,
            val_bool
        );
        // Use of value expressions in function call
        let _sig_result = call_signature_and_test(val_u8, val_u16, val_u32, val_bool);
    }

    // Called function to test passing generated parameter values
    public fun call_signature_and_test(
        a: u8,
        b: u16,
        c: u32,
        d: bool
    ): vector<u8> {
        param_signature_generator(a, b, c, d)
    }

    
//# publish
    module 0xBADD::VisibilityTest {
        // Function with public visibility
        public fun public_func() {
        }
        // Function with public(script) visibility
        public(script) fun script_func() {
        }
        // Function with private visibility
        fun private_func() {
        }
    }

    // Function attempting cross-module calls with different visibility levels
    public fun cross_module_visibility() {
        // Valid call: public
        0xBADD::VisibilityTest::public_func();

        // Valid call: public(script)
        0xBADD::VisibilityTest::script_func();

        // Invalid call: private cannot be accessed outside the module
        // 0xBADD::VisibilityTest::private_func(); // This should be commented or cause compile error if uncommented
    }

    // Function testing various expression value embeddings
    public fun test_value_expressions() {
        // Use literals directly in function call
        _ = call_signature_and_test(1u8, 2u16, 3u32, false);

        // Use constant variables
        let c1 = 10u8;
        let c2 = 20u16;
        let c3 = 30u32;
        let c4 = true;
        _ = call_signature_and_test(c1, c2, c3, c4);

        // Embed in complex expressions
        let res = call_signature_and_test(
            c1 + 5u8,
            c2 * 2,
            c3 - 10,
            !c4
        );
    }

    
//# run 0xCAFE::TestInteraction::generate_value_exprs

    
//# run 0xCAFE::TestInteraction::cross_module_visibility

    
//# run 0xCAFE::TestInteraction::test_value_expressions


// Featurres:
// 54439346b3ff0affe674c4e0fef60b6d: Generate a comma-separated list of function parameters with their types in Move syntax.
// b14465536836359191081c70d1e70f88: Use value expressions to embed constant or literal values in your code.
// 0cc62a3217f97e8703f73eb151a98449: Ensure that functions called across modules are accessible based on their visibility and the calling context.
