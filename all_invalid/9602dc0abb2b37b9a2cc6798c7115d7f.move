
//# publish
module 0xBADD::VisibilityTests {
    use std::signer;

    // Module with various function visibilities
    struct HiddenStruct has copy, drop, store {
        data: u64,
    }

    // Public function
    public fun public_fn(): u64 {
        42
    }

    // Friend function accessible only from this module or trusted modules
    friend fun friend_fn(): u64 {
        100
    }

    // Private function (by default, functions are private; explicitly using 'private' for clarity)
    private fun private_fn(): u64 {
        999
    }

    // Function that calls other functions based on visibility
    public fun call_functions(): (u64, u64, u64) {
        let val_pub = public_fn();
        let val_fri = friend_fn();
        let val_priv = private_fn();
        (val_pub, val_fri, val_priv)
    }

    // Function to test variable declarations and error handling
    public fun variable_handling_and_error(s: signer) {
        // Proper variable declaration with initialization
        let x: u8 = 10;
        let y = 20u8;

        // Using `let` without initialization should produce a diagnostic (simulate by intentional error below)
        // let z: u8; // This would be invalid because 'let' must be initialized in Move

        // Generate an error intentionally: mismatched token
        // The following line is invalid, designed intentionally for error diagnostics
        // `let _ = 1;` is valid, but to induce an error, use incorrect syntax:
        // `let _ = 1  ;` with a typo or malformed syntax would cause the compiler diagnostic
        // However, in script, we simulate with a comment:
        // uncommenting the next line simulates a diagnostic in tests
        // illegal_token

        // Assign to local variable with explicit type
        let total: u16 = (x as u16) + (y as u16);
        // Use 'total' for something
        let _ = total;
    }
}


//# run 0xBADD::VisibilityTests::call_functions


//# run 0xBADD::VisibilityTests::variable_handling_and_error --signers 0xDEAD


// Featurres:
// c1a75e6c57507d435f50799561012d9c: Control function visibility using visibility specifiers like 'public', 'friend', or 'private'.
// 0e32b2939691f875afce97f0ebf65be8: Declare local variables using 'let', optionally with a type annotation and/or initialization expression.
// 8031f4c64cc258757a85b6555a15b7be: Handle errors by generating a diagnostic if the token does not match
