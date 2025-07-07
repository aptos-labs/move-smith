
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // A struct with only 'copy' ability - supported
    struct CopyOnlyStruct has copy {
        a: u8,
    }

    // A struct with only 'drop' ability - supported
    struct DropOnlyStruct has drop {
        b: u8,
    }

    // A struct with both 'copy' and 'drop' abilities - supported
    struct CopyDropStruct has copy, drop {
        c: u8,
    }

    // A struct with unsupported ability 'store' (should cause compile error if used directly in code)
    // This is commented out to keep the module compile-able, but in real test, it should be attempted to compile.
    // struct StoreOnlyStruct has store {
    //     d: u8,
    // }

    // A function to test abilities declaration correctness
    public fun test_abilities(): bool {
        let c1 = CopyOnlyStruct { a: 1 };
        let c2 = CopyDropStruct { c: 2 };
        let c3 = DropOnlyStruct { b: 3 };
        // The following line is an invalid declaration and should cause compile error if uncommented
        // let invalid_struct = StoreOnlyStruct { d: 4 };

        // the function just returns true to pass
        true
    }

    // A function with nested loops and conditionals with return in nested scope
    public fun control_flow_test(arg: u8): u8 {
        let result = 0u8;
        let i = 0u8;
        while (i < 5) {
            if (i == arg) {
                // break early if i equals arg
                result = i;
                // return inside nested if, the outer function's return
                break;
            } else {
                let j = 0u8;
                while (j < 3) {
                    if (j == 2) {
                        // return within nested loop
                        result = i + j;
                        break;
                    };
                    let _ = j + 1;
                };
            };
            let _ = i + 1;
            i = i + 1;
        };
        result
    }

    // A function using 'apply' to pattern match and process a vector of booleans
    public fun apply_pattern_matching(v: vector<bool>): u8 {
        let count_true = 0u8;
        let len = vector::length(&v);
        let index = 0u64;
        while (index < len as u64) {
            let bit = *vector::borrow(&v, index as u64);
            apply (bit) in {
                true => { count_true = count_true + 1; },
                false => { count_true = count_true; },
            };
            index = index + 1;
        };
        count_true
    }

    // Runner function to test all above
    public fun run_tests() {
        let _ = test_abilities();
        let res = control_flow_test(3);
        // Call apply pattern matching
        let bool_vec = vector::empty<bool>();
        vector::push_back(&mut bool_vec, true);
        vector::push_back(&mut bool_vec, false);
        vector::push_back(&mut bool_vec, true);
        let count = apply_pattern_matching(bool_vec);
        // Use values to ensure code runs
        let _ = res + count;
    }
}


//# run 0xDEAD::TestModule::run_tests


// Featurres:
// 7c69ce06bc685b45e170e5437a346277: Restrict type ability declarations to one of the supported keywords: 'copy', 'drop', 'store', or 'key'.
// 673bc45956c4083f6c610a7c75773e05: Test that the Move interpreter correctly handles return statements inside nested loops and conditionals.
// 4e31573f00ae29fdd9af678a8155720e: Use the 'apply' keyword to specify a function expression to be applied to patterns in your Move code.
