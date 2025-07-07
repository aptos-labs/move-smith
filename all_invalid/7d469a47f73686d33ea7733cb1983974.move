
//# publish
module 0xCAFE::VectorUtils {
    use std::vector;

    public fun remove_at<T: copy + drop>(vec: &mut vector<T>, index: u64) {
        let len = vector:: length(vec);
        assert!(index < len, 999);
        let _ = vector:: remove(vec, index);
    }

    public fun sum_vector(vec: &vector<u64>): u64 {
        let acc = 0u64;
        let len = vector:: length(vec);
        let i = 0;
        while (i < len) {
            let val = *vector:: index(vec, i);
            acc = acc + val;
            i = i + 1;
        }
        acc
    }
}


//# publish
module 0xCAFE::TestRemoveAndFold {
    use 0xCAFE::VectorUtils;
    use std::vector;

    // Function to test removing an element at a specific index
    public fun test_remove_at() {
        let vec: vector<u64> = vector::empty<u64>();
        vector::push_back(&mut vec, 0x1u64);
        vector::push_back(&mut vec, 0x2u64);
        vector::push_back(&mut vec, 0x3u64);
        // Remove element at index 1
        VectorUtils::remove_at(&mut vec, 1);

        // Expected vec: [0x1, 0x3]
        // fold over vector to check sum
        let total = VectorUtils::sum_vector(&vec);
        assert!(total == 0x1 + 0x3, 777);
    }

    // Function to test folding over a vector multiplied by 2
    public fun test_fold() {
        let vec: vector<u64> = vector::empty<u64>();
        vector::push_back(&mut vec, 0x10);
        vector::push_back(&mut vec, 0x20);
        vector::push_back(&mut vec, 0x30);
        let sum_times_two = 0u64;
        let len = vector::length(&vec);
        let i = 0;

        while (i < len) {
            let val = *vector::index(&vec, i);
            sum_times_two = sum_times_two + (val * 2);
            i = i + 1;
        }
        // sum_times_two should be (0x10*2 + 0x20*2 + 0x30*2) = 0x20 + 0x40 + 0x60 = 0x120
        assert!(sum_times_two == 0x120, 778);
    }
}


//# run 0xCAFE::TestRemoveAndFold::test_remove_at

//# run 0xCAFE::TestRemoveAndFold::test_fold

// Featurres:
// 5c962dd46f28c462b4b8a944a355b747: Use hexadecimal number literals in your Move code.
// b9d48b9d204b494f42b571833757e85b: Test that the custom remove function correctly removes an element at a specified index from a vector and that folding over a vector produces the expected result.
// 9def49343c650663209a2268dd6c0e84: Define Move modules to encapsulate related code and resources.
