
//# publish
module 0xCAFE::ControlFlowTest {
    use std::signer;

    // This function tests the control of compilation stages with flags by simulating flags.
    // As per the guidelines, the flags are conceptual, but in real scenario, you'd control compilation flags.
    public fun compile_with_flags(flag_stop_before_parse: bool, flag_stop_before_type_check: bool): bool {
        // Simulation: just return true if flags are valid, in real test, flags would control compile stage.
        flag_stop_before_parse || flag_stop_before_type_check
    }

    // Patterned specification that creates pattern with identifiable parts
    // Pattern pattern: "[abc]*def*xyz" to test pattern matching
    public fun pattern_match(pattern: vector<u8>, text: vector<u8>): bool {
        // Simple string pattern matching (not efficient, just for test)
        let i = 0;
        let j = 0;
        while (i < vector::length(&text) && j < vector::length(&pattern)) {
            let p_char = *vector::borrow(&pattern, j);
            if p_char == b'*' {
                // Skip all subsequent pattern characters until match
                j = j + 1;
                continue;
            }
            let t_char = *vector::borrow(&text, i);
            if p_char != t_char {
                // Handle wildcard in pattern
                if p_char == b'*' {
                    j = j + 1;
                } else {
                    return false;
                }
            } else {
                i = i + 1;
                j = j + 1;
            }
        }
        // After reaching end of pattern, check if text is exhausted or pattern has wildcard
        if (j == vector::length(&pattern)) {
            // pattern processed
            true
        } else {
            false
        }
    }

    // Borrow reference mutably and immutably
    public fun test_borrowing(s: signer): (u8, u8, u8, u8) {
        // Create a local variable
        let val = 42u8;
        let val_ref: &u8 = borrow_global::<u8>(&signer::address_of(&s)); // borrowing
        // mutable borrow
        let val_mut_ref: &mut u8 = borrow_global_mut::<u8>(&signer::address_of(&s));
        val_mut_ref.x = 1;
        // Use references
        let _ = *val_ref;
        let _ = *val_mut_ref;
        // For test purposes, return different values
        (val, *val_ref, *val_mut_ref, 255u8)
    }

    // Pattern pattern: create a test pattern string with mocked fragmented parts and wildcards
    public fun pattern_fragments_test(): bool {
        let pattern1 = b"abc*def*xyz";
        let text1 = b"abcdefXYZ"; // partially matching
        pattern_match(pattern1, text1)
    }
}


//# run 0xCAFE::ControlFlowTest::compile_with_flags --args true false


//# run 0xCAFE::ControlFlowTest::pattern_match --args b"abc*def*xyz" b"abcdefXYZ"


//# run 0xCAFE::ControlFlowTest::test_borrowing --signers 0xBADD --args 0u8


// Featurres:
// 3e8be9aeafaf0bb225fa5b382e0efb19: Control compilation stages with experiment flags for stopping before certain phases.
// beed001108a54ff28941535d37c42e3d: Create specification patterns with a name pattern composed of identifier fragments and asterisks, allowing adjacent identifier fragments or wildcards without spaces.
// b9982ef090f7ae0d6df6fddd9e46c333: Borrow references mutably or immutably with the `borrow` expression.
