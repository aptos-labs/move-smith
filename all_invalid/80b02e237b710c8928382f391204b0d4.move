
//# publish
module 0xC0FFEE::InteractionTest {
    use std::signer;
    use std::debug;

    // Internal variable declared at module scope, only accessible within this module
    var internal_var: u64;

    // Internal function to modify internal_var
    // Declared as internal, should not be accessible externally
    fun internal_increment() {
        internal_var = internal_var + 1;
    }

    // Public script entry point to invoke internal functions
    public fun initialize_and_increment(signer_addr: address) {
        let s = signer::new_signer(signer_addr);
        // Call internal function
        internal_increment();
        // After increment, internal_var should be 1
        assert!(internal_var == 1, 100);
    }

    // Internal function that performs nested variable handling and shadowing
    fun variable_shadowing_logic() {
        let outer_var: u64 = 10;
        // Shadow outer_var with inner declaration inside a block
        {
            let outer_var: u64 = 20; // shadow
            // Inside this block, outer_var should be 20
            assert!(outer_var == 20, 101);
        }
        // Outside block, outer_var should be original 10
        assert!(outer_var == 10, 102);
    }

    // Function to test variable handling inside a while loop
    public fun variable_handling_in_loop() {
        let count: u64 = 0;
        let sum: u64 = 0;
        while (count < 5) {
            // Declare a variable inside loop
            let inner_var: u64 = count * 2;
            // Reassign count and sum
            count = count + 1;
            sum = sum + inner_var;
            // Assert inner_var is correct
            assert!(inner_var == (count - 1) * 2, 103);
        };
        // After loop, verify count and sum
        assert!(count == 5, 104);
        // sum should be 0+2+4+6+8=20
        assert!(sum == 20, 105);
    }

    // Function to test variable declaration outside and inside loop, and reassignment
    public fun variables_outside_inside_loop() {
        let total: u64 = 0;
        // Declare variable outside loop
        let loop_var: u64 = 0;
        while (loop_var < 3) {
            // Shadow with inner variable
            {
                let loop_var: u64 = loop_var + 1; // shadow
                total = total + loop_var;
                // innver loop_var should be +1
                assert!(loop_var <= 3, 106);
            }
            // Reassign outer loop_var
            loop_var = loop_var + 1;
        };
        // After loop, total should be 1+2+3=6
        assert!(total == 6, 107);
    }

    // Function to attempt external access to internal variables/ functions
    public fun external_access_attempt() {
        // Attempt to call internal function - should fail compilation if called externally
        // For test purposes, we simulate calling internally
        internal_increment();
        // Assert internal_var incremented
        assert!(internal_var == 1, 108);
        // Try to access internal_var directly - should not be possible outside this module
        // But here we can access since in same module
        // So, simulate external access attempt: (commented as it would fail outside compile)
        // let _ = external_variable_access();
        // The access is restricted by visibility; no code here, just testing via comment
    }
}


//# run 0xC0FFEE::InteractionTest::initialize_and_increment --signers 0xBADD --args 0xBADD


//# run 0xC0FFEE::InteractionTest::variable_shadowing_logic


//# run 0xC0FFEE::InteractionTest::variable_handling_in_loop


//# run 0xC0FFEE::InteractionTest::variables_outside_inside_loop


//# run 0xC0FFEE::InteractionTest::external_access_attempt


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
