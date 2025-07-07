
//# publish
module 0xCAFE::TestInteraction {
    use std::signer;
    use std::vector;

    // Internal variable for testing internal visibility
    const INTERNAL_CONST: u8 = 42;

    // Internal struct, not public
    struct InternalStruct has copy, drop {
        value: u8,
        secret: bool,
    }

    // Public struct for testing access
    struct PublicStruct has copy, drop {
        data: u64,
    }

    // Public functions
    public fun call_internal_function(s: signer) {
        internal_func(s);
    }

    // Internal function with internal visibility
    fun internal_func(_s: signer) {
        // do nothing, just internal logic
    }

    // Function to create a local variable and shadowing inside loops
    public fun variable_shadowing_test() {
        let a = 10u8;
        let b = 20u8;
        // Outer scope variables
        // Shadowing within while loop
        let i = 0;
        while (i < 3) {
            let a = a + 1; // shadow
            let b = b + 2; // shadow
            // Assert that shadowed variables have correct values
            assert!(a == (10 + i + 1), 1000);
            assert!(b == (20 + i * 2 + 2), 1001);
            i = i + 1;
        }; // <-- added missing semicolon here
        // After loop, variables retain their original values
        assert!(a == 10, 1002);
        assert!(b == 20, 1003);
    }

    // Function to test variable assignment outside loop
    public fun variable_assignment_outside_loop() {
        let c = 5u8;
        // Assign new value
        let c = c + 3; // shadowing is deliberate here, but the variable is re-bound
        // c should now be 8
        assert!(c == 8, 1004);
        // Shadowed variable inside block
        let c = c + 10; // new c shadows outer c
        // inner c, should be 18
        assert!(c == 18, 1005);
    }

    // Function to test that shadowing does not carry over
    public fun shadowing_is_isolated() {
        let d = 1u8;
        {
            let d = d + 1; // shadow
            assert!(d == 2, 1006);
        }
        // after inner scope, d remains unchanged
        assert!(d == 1, 1007);
    }

    // Function to test access to internal variables and functions
    public fun test_internal_access(s: signer) {
        // Call internal function from within module (allowed)
        internal_func(s);
        // Access internal constant (allowed)
        let val = INTERNAL_CONST;
        assert!(val == 42, 1008);
        // Access internal struct (allowed)
        let s_struct = InternalStruct { value: 7, secret: true };
        // Create PublicStruct for further testing
        let p_struct = PublicStruct { data: 123 };
        assert!(p_struct.data == 123, 1009);
    }

    // Function to test that external modules cannot access internal functions/variables
    // Do not call from outside this module; this is a placeholder for compile-time check
    // (Cannot do actual compile-time test here, but conceptually described)

    // Function with specification attached using target
    public fun spec_attachment_test() {
        // target: pre
        /*@
        ensures true;
        @*/
        let _ = 1u8;
        // target: post
        /*@
        ensures true;
        @*/
        let _ = 2u8;
    }
}

// Scripts to test the above module



//# run 0xCAFE::TestInteraction::variable_shadowing_test



//# run 0xCAFE::TestInteraction::variable_assignment_outside_loop



//# run 0xCAFE::TestInteraction::shadowing_is_isolated



//# run 0xCAFE::TestInteraction::test_internal_access --signers 0xBEEF



//# run 0xCAFE::TestInteraction::spec_attachment_test


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// c6bb630462f497a4cb0875d5259aeddb: Avoid unnecessary acquire annotations by removing declared complies that the compiler can infer are acquired within function bodies.
// 1249ce86d777852c3ca977dcfb335bf6: Attach specification blocks to specific Move language constructs using the 'target' mechanism.
