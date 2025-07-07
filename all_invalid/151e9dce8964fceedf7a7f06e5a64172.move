
//# publish
module 0xCAFE::VectorTest {
    use std::vector;

    public fun test_copy_move_in_loop() {
        let v: vector<u8> = vector::empty();
        vector::push_back(&mut v, 1u8);
        vector::push_back(&mut v, 2u8);
        vector::push_back(&mut v, 3u8);

        let v_copy = vector::copy(&v);
        let v_moved = vector::move(&v);

        let result: u8 = 0u8;

        let i = 0;
        loop {
            if (i >= vector::length(&v_copy)) {
                break;
            }
            let elem = *vector::borrow(&v_copy, i);
            if (elem == 2u8) {
                // simulate continue
                i = i + 1;
                continue;
            }
            if (elem == 3u8) {
                // simulate abort
                abort 999;
            }
            result = result + elem;
            i = i + 1;
        };

        // Code following a return (aborted) is not executed but should be type-checked
        // We'll place a dummy return here
        result
    }

    public fun test_anonymous_address() {
        let addr_bytes: vector<u8> = b"00000000000000000000000000XX";
        let addr_bytes_copy = vector::copy(&addr_bytes);
        // Create an address from bytes (assuming 16 bytes in total)
        let addr_bytes_fixed: vector<u8> = if (vector::length(&addr_bytes_copy) == 16) {
            vector::copy(&addr_bytes_copy)
        } else {
            vector::empty()
        };
        // Simulate the creation of an address (in actual Move, address creation may not accept raw bytes)
        // Just verify copying and length
        assert!(vector::length(&addr_bytes_fixed) == 16, 0);
        addr_bytes_fixed
    }

    public fun test_code_after_return() {
        // Code after return
        return;
        // This code is unreachable but should be type checked during verification
        let _dummy = 42u8;
    }

    public fun runner() {
        let _ = test_copy_move_in_loop();
        let _ = test_anonymous_address();
        let _ = test_code_after_return();
    }
}


//# run 0xCAFE::VectorTest::runner

// Featurres:
// ad9d92aeb397df9e0305ba010ef71aca: Test that a vector can be safely copied and moved after taking a reference to it inside a loop with control flow statements like break, continue, and abort without causing invariant violations.
// afadbd38b9c79cbff7bf974004e7410a: Use anonymous addresses with specified byte sequences in Move code.
// 35ece762deaa8a1ab9b68841a34fac20: Test that code following a return statement is still type checked and executed during verification, even if it is unreachable.
