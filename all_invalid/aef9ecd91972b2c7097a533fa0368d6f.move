
//# publish
module 0xCAFE::TestNativeFunctions {
    native fun native_add(x: u64, y: u64): u64;

    public fun test_native_add() {
        let result = native_add(10, 20);
        // Typically you'd assert or test result here, but per instructions, assertions are omitted.
    }

    native fun native_multiply(x: u64, y: u64): u64 {
        // No body, just declaration
        // This is to test native function declaration without body
        abort 1;
    }
}



//# publish
module 0x42::m {
    use std::vector;

    struct KEYS {
        keys: vector<u64>,
    }

    struct VALUES {
        values: vector<u64>,
    }

    // Maintains a global vector of keys and values
    static mut KEYS_VEC: vector<u64> = vector::empty<u64>();
    static mut VALUES_VEC: vector<u64> = vector::empty<u64>();

    public fun init(keys: vector<u64>, values: vector<u64>): () {
        // Map KEYS to KEYS with each element multiplied by 2
        let new_keys = vector::map(&keys, |k| k * 2);
        // Map VALUES to VALUES with each element increased by 10
        let new_values = vector::map(&values, |v| v + 10);

        // Store mapped vectors in global storage
        unsafe {
            KEYS_VEC = new_keys;
            VALUES_VEC = new_values;
        }
    }
}



//# run 0x42::m::init --args vectoru64[1,2,3], vectoru64[4,5,6]



//# run 0x42::m::init --args vectoru64[10,20], vectoru64[30,40]



//# run 0xCAFE::TestNativeFunctions::test_native_add --signers 0xBEEF



//# run 0xCAFE::TestNativeFunctions::native_multiply --signers 0xBEEF