
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

    // Move does not support 'private' visibility specifier; functions are private by default if no visibility is specified
    // To make a function private, simply omit the 'public' or 'friend' specifier
    fun private_fn(): u64 {
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

        // Using `let` without initialization causes compile error in Move
        // let z: u8; // invalid, commented out
        
        // To simulate an erroneous token, introduce a comment
        // or invalid syntax intentionally (not executable code)
        // e.g., invalid_token

        // Assign to local variable with explicit type
        let total: u16 = (x as u16) + (y as u16);
        // Use 'total' for something
        let _ = total;
    }
}



//# run 0xBADD::VisibilityTests::call_functions



//# run 0xBADD::VisibilityTests::variable_handling_and_error --signers 0xDEAD


// Features:
// c1a75e6c57507d435f50799561012d9c: Control function visibility using visibility specifiers like 'public' or 'friend'.
// 0e32b2939691f875afce97f0ebf65be8: Declare local variables using 'let', optionally with a type annotation and/or initialization expression.
// 8031f4c64cc258757a85b6555a15b7be: Handle errors by intentionally invalid syntax or comments to induce diagnostics
