
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
            let x = x_moved + 1;
        } else {
            let x = x_moved - 1;
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
        // In Move, typically you'd use the signer provided by the test environment.
        // For illustration purposes, we return an address literal or use a dummy address.
        // Replace with correct signer address fetching as per your test setup.
        0xBADD0000
    }
}

// Note: 
// - The primary fix was to replace the assignment `x = ...;` with local bindings inside if-else blocks, 
//   because Move doesn't allow variable reassignment.
// - Also, fixed function `signer_address()` to return an address literal to avoid compilation errors.
// - The rest of your control flow seems fine.