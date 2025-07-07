//# publish
module 0x1::break_test {
    // Function to test early termination with 'break' inside a loop
    public fun test_break_once() {
        let mut i = 0;
        while (i < 10) {
            // Break immediately on first iteration
            break;
            // The following assertion won't be reached
            assert!(false, 42);
            i = i + 1;
        }
    }

    // Function to test that code after 'break' is not executed
    public fun test_break_and_continue() {
        let mut sum = 0;
        let mut i = 0;
        while (i < 5) {
            if (i == 2) {
                break; // Exit loop when i == 2
            }
            // This should only run for i=0 and i=1
            sum = sum + i;
            i = i + 1;
        }
        // optional: return sum (not required here)
    }

    // Specification block starting with 'spec'
    spec {
        // Check that test_break_once exits immediately after break
        // (no assertion inside test, but included for completeness)
    }

    // Function to decode hexadecimal escape sequences
    public fun decode_hex_escape() {
        let bytes = b"\x48\x65\x6C\x6C\x6F"; // "Hello" in hex escape sequences
        // no assertion needed
    }
}

// //# run 0x1::break_test::test_break_once --signers 0xA --args
//# run 0x1::break_test::test_break_and_continue --signers 0xA
//# run 0x1::break_test::decode_hex_escape --signers 0xA