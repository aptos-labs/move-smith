
//# publish
module 0xCAFE::DebugTest {
    use std::vector;
    use std::print;
    use std::option;

    // 1. Helper function to print debug representation
    // Corrected: 'AstDebug' is not an existing trait; assuming we want to print anything that implements std::debug::Debug
    use std::debug;

    public fun print_debug<T: copy + drop + debug::Debug>(val: T) {
        print(&format_args!("{:?}\n", val));
    }

    // 2. Function that tests vector copying/moving, with control flow statements
    public fun test_vector_control_flow(v: vector<u8>): bool {
        let index: u64 = 0; // 'mut' needed for mutation
        // Loop with break, continue, and abort
        while (index < vector::len(&v)) {
            let element = *vector::borrow(&v, index);
            if (element == 0) {
                // continue to next iteration
                index = index + 1;
                continue;
            } else if (element == 255) {
                // abort the transaction
                abort 42;
            } else if (element == 128) {
                // break out of the loop
                break;
            }
            index = index + 1;
        }

        // Take a reference, then check vector can still be used after
        let v_ref: &vector<u8> = &v;
        // Copy the vector
        let v_copy: vector<u8> = vector::copy(&v);
        // Mutably move vector (simulate move by removing first element)
        // Note: move semantics are different; using swap_remove for a similar effect
        let v_moved: vector<u8> = vector::swap_remove(&mut v, 0);
        // Use the references and copies to verify invariants
        print_debug(vector::len(&v_ref));
        print_debug(vector::len(&v_copy));
        print_debug(vector::len(&v_moved));

        true
    }

    // 3. Function with specified return type to verify return types
    public fun return_u8(x: u8): u8 {
        x + 1
    }

    public fun return_bool(flag: bool): bool {
        if (flag) {
            true
        } else {
            false
        }
    }

    // Runner function to execute all tests
    public fun run_tests() {
        let vec = vector::empty<u8>();
        // populate vector for testing
        let _ = vector::push_back(&mut vec, 1);
        let _ = vector::push_back(&mut vec, 0);
        let _ = vector::push_back(&mut vec, 128);
        let _ = vector::push_back(&mut vec, 255);
        let _ = vector::push_back(&mut vec, 5);

        assert!(test_vector_control_flow(vector::copy(&vec))); // expected to succeed unless abort triggered

        let _ = print_debug(return_u8(10));
        let _ = print_debug(return_bool(true));
    }
}


//# run 0xCAFE::DebugTest::run_tests --signers 0xBADD --args