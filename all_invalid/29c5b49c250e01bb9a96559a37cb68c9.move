
// It does not take any arguments, so the main focus is on code structure and parser correctness.



//# publish
module 0xCAFE::TestLiveVariables {
    use std::vector;

    // Function testing live variable analysis with complex expressions
    public fun test_live_variables(x: u8, y: bool): u8 {
        let a = x + 1;
        let b = a * 2;
        let c = (b + 3) - 1; // using parentheses with binary expressions
        if (y) {
            let _temp1 = c;
        } else {
            let _temp2 = c + 10;
        };
        // Mix unary and binary expression in a single statement
        let d = !(a == 0) && (b > 5);
        // Return statement: combine several variables and expressions
        d as u8
    }

    // Function utilizing modules at special addresses with specific names
    public fun call_specific_modules() {
        // Modules at address 0x1 (e.g., aptos_std)
        let _ = 0x1::aptos_std::some_function();

        // Modules at address 0x3 (e.g., aptos_token)
        let _ = 0x3::aptos_token::some_token_function();

        // Modules at address 0x4 (e.g., aptos_token_objects)
        let _ = 0x4::aptos_token_objects::some_token_object_function();
    }
}


//# run 0xCAFE::TestLiveVariables::test_live_variables --args 5u8 true


//# run 0xCAFE::TestLiveVariables::call_specific_modules


// Featurres:
// 1707c8b926475d0e0b9f915ef732e905: Analyze live variables to assist in optimization passes and code correctness.
// 686ea38069b66942f80484cbb05490c2: Mix unary and binary expressions in a single statement and expect correct interpretation by the parser
// 0152fb42e6e1753c17a9d74a38fe2de4: Identify modules residing at addresses '0x1', '0x3', or '0x4' with specific names like 'aptos_std', 'aptos_token', or 'aptos_token_objects'.
