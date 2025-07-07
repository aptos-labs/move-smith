//# publish
module 0xCAFE::DiagnosticsTest {
    use std::vector;

    struct ByteStore has key, store {
        data: vector<u8>
    }

    public fun create_store(account: &signer) {
        let data = vector[1u8, 2u8, 3u8, 4u8, 5u8];
        move_to<ByteStore>(account, ByteStore { data });
    }

    public fun sum_and_empty(account: &signer): u64 {
        let store_ref = borrow_global_mut<ByteStore>(signer::address_of(account));
        let mut total: u64 = 0;

        // Pop all elements from vector, summing them
        while (vector::length(&store_ref.data) > 0) {
            let b = vector::pop_back(&mut store_ref.data);
            total = total + (b as u64);
        };
        total
    }

    public fun trigger_error_with_diagnostics() {
        // Intentionally cause an overflow error for diagnostics testing
        let x: u8 = 200;
        let y = x + 100; // This should produce diagnostic message for overflow
        let _ = y;
    }
}

//# run 0xCAFE::DiagnosticsTest::create_store --signers 0xBADA

//# run 0xCAFE::DiagnosticsTest::sum_and_empty --signers 0xBADA

//# run 0xCAFE::DiagnosticsTest::trigger_error_with_diagnostics

// Featurres:
// f723b5c7022787c7dfe47a28d29df933: Associate diagnostic messages with source code ranges to highlight exact locations of problems.
// a1ad462cbc0e7bcd76a00bf1c879a902: Treat an entire Move program as a compilation target for whole-program analysis.
// 7089c4cd06ddee8834d2c0ab2858e857: Test that popping all elements from a vector of bytes and summing them produces the correct total.
