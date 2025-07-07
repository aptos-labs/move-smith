
//# publish
module 0xCAFE::LoopTest {
    use std::vector;

    // Declare a module-level constant
    const MAX_COUNT: u64 = 5;

    public fun nested_for_loop_result() acquires {} {
        // Initialize sum to accumulate results
        let sum: u64 = 0;

        // Outer loop: from 0 to MAX_COUNT inclusive
        for i in 0..(MAX_COUNT + 1) {
            // Inner loop: from i to MAX_COUNT inclusive
            for j in i..(MAX_COUNT + 1) {
                // Accumulate the sum with current indices
                sum = sum + i + j;
            }
        }
        // Return the final sum
        sum
    }

    // An example function that creates nested loops over byte ranges
    public fun nested_byte_ranges() acquires {} {
        let total: u64 = 0;
        let bytes1 = vector {0x01, 0x02, 0x03};
        let bytes2 = vector {0x0A, 0x0B};
        let len1 = vector::length(&bytes1);
        let len2 = vector::length(&bytes2);
        let i = 0;
        while (i < len1) {
            let byte1 = *vector::borrow(&bytes1, i);
            let j = 0;
            while (j < len2) {
                let byte2 = *vector::borrow(&bytes2, j);
                total = total + (byte1 as u64) + (byte2 as u64);
                j = j + 1;
            }
            i = i + 1;
        }
        total
    }
}


//# run 0xCAFE::LoopTest::nested_for_loop_result

//# run 0xCAFE::LoopTest::nested_byte_ranges

// Featurres:
// 838ed5579f230c84b221c30b884415c8: Test that nested for-in loops over integer ranges correctly maintain and update loop variables and compute the expected final result.
// afadbd38b9c79cbff7bf974004e7410a: Use anonymous addresses with specified byte sequences in Move code.
// 7111f53b42d3f84e91f3e1d4229edb5d: Declare module-level constants using the 'const' keyword followed by a name, type, value, and semicolon.
