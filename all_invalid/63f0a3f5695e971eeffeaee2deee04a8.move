//# publish
module 0xDEAD::TestModule {
    use std::vector;

    struct KeyStruct has key, store {
        id: u64,
        key: bool,
    }

    public fun create_key_struct(id: u64, key: bool): KeyStruct {
        KeyStruct {id, key}
    }

    public fun check_key_and_return(k: &KeyStruct): bool {
        k.key
    }

    public fun create_mutable_ref_for_key(k: &mut KeyStruct): &mut KeyStruct {
        k
    }

    // Function to test recognized 'Key' ability
    public fun test_key_ability(): bool {
        let ks = create_key_struct(42, true);
        let is_key = check_key_and_return(&ks);
        is_key
    }

    // Function to test mutable references with '&mut    public fun test_mutable_ref(): bool {
        // Declare a mutable variable
        let ks = create_key_struct(100, false);
        // Get mutable reference
        let ks_mut = create_mutable_ref_for_key(&mut ks);
        ks_mut.id = 999;
        // Check if mutation occurred
        ks_mut.id == 999
    }

    // Function to test labeled continue in nested loops
    public fun test_labeled_continue(): u64 {
        let sum = 0u64;
        'outer: for i in 0..5 {
            for j in 0..5 {
                if (i + j) == 3 {
                    continue 'outer;
                }
                sum = sum + (i + j) as u64;
            }
        }
        sum
    }
}
