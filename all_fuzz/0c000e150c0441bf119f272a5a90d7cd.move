
//# publish
module 0xCAFE::HexAndEnvTest {
    use std::vector;

    const HEX_BYTES: vector<u8> = x"DEADC0DE";

    // Return the hard-coded hex byte string vector
    public fun get_hex_bytes(): vector<u8> {
        HEX_BYTES
    }

    // A simple function that converts hex bytes vector into u8 sum
    public fun sum_bytes(v: vector<u8>): u64 {
        let s: u64 = 0;
        let len = vector::length(&v);
        let i = 0;
        while (i < len) {
            // vector::borrow returns &u8, need to dereference to get u8 for cast
            s = s + ((*vector::borrow(&v, i)) as u64);
            i = i + 1;
        };
        s
    }

    // Dummy functions simulating access to environment variables for experimental compiler features
    // In real environment these would come from VM or compile-time flags
    public fun mvc_experiment_enabled(): bool {
        // returning true to simulate experiment enabled
        true
    }

    public fun move_compiler_exp_enabled(): bool {
        // returning false to simulate experiment disabled
        false
    }

    // Function that tests conditional logic based on env experiment flags
    public fun test_exp_features(): u8 {
        if (mvc_experiment_enabled()) {
            42
        } else if (move_compiler_exp_enabled()) {
            24
        } else {
            0
        }
    }
}



//# run 0xCAFE::HexAndEnvTest::get_hex_bytes



//# run 0xCAFE::HexAndEnvTest::sum_bytes --args x"DEADC0DE"



//# run 0xCAFE::HexAndEnvTest::mvc_experiment_enabled



//# run 0xCAFE::HexAndEnvTest::move_compiler_exp_enabled



//# run 0xCAFE::HexAndEnvTest::test_exp_features
