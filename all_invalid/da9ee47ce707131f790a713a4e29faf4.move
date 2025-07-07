
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
        let ks = create_key_struct(100, false);
        let ks_mut = create_mutable_ref_for_key(&mut ks);
        ks_mut.id = 999;
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


//# run 0xDEAD::TestModule::test_key_ability


//# run 0xDEAD::TestModule::test_mutable_ref


//# run 0xDEAD::TestModule::test_labeled_continue


// Featurres:
// 2faf08043df5a65deef7d74267cba515: Recognize the 'Key' ability when the token is an identifier with content 'KEY'.
// d35b588c67cd02c800b53cd7282965d0: Use '&mut' to define mutable references in types.
// afca2256674b4b25f00b44bf75c8675d: Test that labeled continue statements correctly break out of nested loops and ensure the final result matches the expected value after multiple labeled continues.
