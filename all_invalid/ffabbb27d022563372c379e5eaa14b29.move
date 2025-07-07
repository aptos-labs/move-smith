//# publish
module 0x1::TestBooleans {
    public fun runner() {
        let b_true = true;
        let b_false = false;
        // Just to use them so optimizer won't remove
        let _ = b_true;
        let _ = b_false;
    }
}

//# run 0x1::TestBooleans::runner


//# publish
module 0x1::TestHexStrings {
    fun decode_hex_and_check(): vector<u8> {
        // Hex string literal to bytes vector
        let v = b"\x01\x23\x45\x67\x89\xab\xcd\xef";
        v
    }

    public fun runner() {
        let _ = decode_hex_and_check();
    }
}

//# run 0x1::TestHexStrings::runner


//# publish
module 0x1::TestShouldRemoveNode {

    #[verifier(verify_only)]
    fun internal_only_fn(): u64 {
        42
    }

    fun normal_fn(): u64 {
        if (should_remove_node()) {
            // Should be removed when compiled without verification flags
            internal_only_fn()
        } else {
            0
        }
    }

    public fun runner() {
        let _ = normal_fn(); // call without verify flags so internal_only_fn body removed
    }
}

//# run 0x1::TestShouldRemoveNode::runner