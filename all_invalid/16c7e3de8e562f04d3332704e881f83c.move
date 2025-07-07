
//# publish
module 0xCAFE::TestConstantsAndControlFlow {
    use std::vector;

    const MY_CONST: u32 = 0xABCD;
    
    public fun test_variable_reassignment_and_control_flow() {
        let x = 5u32;
        move_to<u32>(&signer_address(), x);
        // move x out for control flow
        let x_moved: u32 = move_from<u32>(&signer_address());
        if (x_moved < 10) {
            x = x_moved + 1;
        } else {
            x = x_moved - 1;
        }
        // Reassign x after moved
        move_to<u32>(&signer_address(), x);
        let _x_final: u32 = move_from<u32>(&signer_address());

        // Using continue with label
        label1:
        for i in 0..3 {
            if (i == 1) {
                continue label1;
            }
            assert!(i != 1, 999);
        }
    }

    public fun signer_address(): address {
        // Placeholder function to get signer's address
        move_from<address>(&signer::address_of(&signer::borrow_signer()))
        // Note: In actual tests, signer address use is fetched differently,
        // but for illustration here, this suffices.
    }
}


//# run 0xCAFE::TestConstantsAndControlFlow::test_variable_reassignment_and_control_flow --signers 0xBADD

// Featurres:
// 7111f53b42d3f84e91f3e1d4229edb5d: Declare module-level constants using the 'const' keyword followed by a name, type, value, and semicolon.
// b0bb423b3ca1fb4d46acb223aba04828: Test that a variable can be reassigned after being moved from and used in an if-else control flow.
// b0ed106f498d18741d0847243d2837a7: Use 'continue' with optional labels.
