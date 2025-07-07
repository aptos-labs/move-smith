
//# publish
module 0xCAFE::LoopAndForeachTest {
    use std::vector;

    // A function to test labeled loops with break and continue
    public fun labeled_loop_test(): u32 {
        let sum: u32 = 0;
        let sum_mut: u32 = sum;
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
                sum_mut = sum_mut + i;
                i = i + 1;
            }
            if (sum_mut >= 10) {
                break 'outer_loop;
            }
            sum_mut = sum_mut + 1;
        }
        sum_mut
    }

    // Function to test allowed optional trailing commas in access specifier lists
    public fun optional_trailing_commas_in_access_specifiers(): bool {
        // The function does nothing but only compiles
        true
    }

    // A function to utilize for-each (foreach) over a vector and sum its elements
    public fun sum_of_vector_elements(vec: vector<u64>): u64 {
        let total: u64 = 0;
        // Simulate for_each over vector elements by iterating with index
        let len = vector::length(&vec);
        let index: u64 = 0;
        while (index < len) {
            let item = *vector::borrow(&vec, index);
            total = total + item;
            index = index + 1;
        }
        total
    }
}


//# run 0xCAFE::LoopAndForeachTest::labeled_loop_test --args


//# run 0xCAFE::LoopAndForeachTest::optional_trailing_commas_in_access_specifiers


//# run 0xCAFE::LoopAndForeachTest::sum_of_vector_elements --args [1u64, 2u64, 3u64, 4u64]