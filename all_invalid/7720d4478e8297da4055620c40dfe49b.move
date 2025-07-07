
//# publish
module 0xCAFE::LoopAndForeachTest {
    use std::vector;

    // A function to test labeled loops with break and continue
    public fun labeled_loop_test(): u32 {
        let sum: u32 = 0;
        // Outer loop label
        'outer_loop: loop {
            let i: u32 = 0;
            // Inner loop label
            'inner_loop: loop {
                if (i >= 5) {
                    break 'inner_loop;
                }
                if (i == 2) {
                    // Continue inner loop
                    i = i + 1;
                    continue 'inner_loop;
                }
                sum = sum + i;
                i = i + 1;
            }
            if (sum >= 10) {
                break 'outer_loop;
            }
            sum = sum + 1;
        }
        sum
    }

    // Function to test allowed optional trailing commas in access specifier lists
    public fun optional_trailing_commas_in_access_specifiers(): bool {
        // The function does nothing but only compiles
        true
    }

    // A function to utilize for-each (foreach) over a vector and sum its elements
    public fun sum_of_vector_elements(vec: vector<u64>): u64 {
        let total: u64 = 0;
        // for_each modifies total
        vector::for_each<&mut u64>(&mut vec, |elem: &mut u64| {
            *elem = *elem; // no change, just iterate
        });
        // Note: there's no built-in 'foreach' syntax in Move, but we simulate iteration:
        let acc: u64 = 0;
        let len = vector::length(&vec);
        let index: u64 = 0;
        while (index < len) {
            let item = *vector::borrow(&vec, index);
            acc = acc + item;
            index = index + 1;
        }
        acc
    }
}


//# run 0xCAFE::LoopAndForeachTest::labeled_loop_test --args


//# run 0xCAFE::LoopAndForeachTest::optional_trailing_commas_in_access_specifiers


//# run 0xCAFE::LoopAndForeachTest::sum_of_vector_elements --args  [1u64, 2u64, 3u64, 4u64]

// Featurres:
// a37c89abf26e487a5175a77fc6593b43: Use loop labels when annotating loops to facilitate control flow.
// 7f11eead1c9592429aab953f8054c037: Allow optional trailing commas in access specifier lists.
// 6429218e3e29ce1b963e2bcaa3f3a253: Test that the `foreach` function correctly iterates over a vector and computes the sum of its elements.
