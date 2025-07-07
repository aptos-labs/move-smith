//# publish
module 0xCAFE::DiagnosticsTest {
    use std::vector;
    use std::signer;

    struct ByteStore has key, store {
        data: vector<u8>
    }

    public fun create_store(account: &signer) {
        let data = vector[1u8, 2u8, 3u8, 4u8, 5u8];
        move_to<ByteStore>(account, ByteStore { data });
    }

    public fun sum_and_empty(account: &signer): u64 {
        let store_ref = borrow_global_mut<ByteStore>(signer::address_of(account));
        sum_vector(&mut store_ref.data)
    }

    fun sum_vector(data: &mut vector<u8>): u64 {
        if (vector::length(data) == 0) {
            0
        } else {
            let b = vector::pop_back(data);
            let rest_sum = sum_vector(data);
            (b as u64) + rest_sum
        }
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