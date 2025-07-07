//# publish
module 0xCAFE::ConsecutiveProduct {
    use std::vector;

    // Computes the product of four consecutive digits in a vector starting at index i
    fun product_of_four(digits: &vector<u8>, i: u64): u64 {
        let d0 = *vector::borrow(digits, i) as u64;
        let d1 = *vector::borrow(digits, i + 1) as u64;
        let d2 = *vector::borrow(digits, i + 2) as u64;
        let d3 = *vector::borrow(digits, i + 3) as u64;
        d0 * d1 * d2 * d3
    }

    // Finds the greatest product of four consecutive digits in the hardcoded digits vector
    public fun max_product_four_consecutive(): u64 {
        let digits = vector[1u8, 3u8, 7u8, 9u8, 2u8, 5u8, 0u8, 4u8, 6u8, 8u8];

        let length = vector::length(&digits);
        // length - 3 because we take groups of 4 digits
        let max_index = length - 4;

        let mut max_product = 0;
        let mut i = 0;
        while (i <= max_index) {
            let prod = product_of_four(&digits, i);
            if (prod > max_product) {
                max_product = prod;
            } else {
                let _x = 0; // dummy else branch statement
            };
            i = i + 1;
        };

        max_product
    }

    // Nested loops with inner and outer breaks to test variable assignments and control flow
    public fun nested_loops_with_breaks(): (u8, u8) {
        let mut outer_count = 0u8;
        let mut inner_count = 0u8;

        loop {
            outer_count = outer_count + 1;
            let mut inner_iter = 0u8;

            loop {
                inner_iter = inner_iter + 1;

                if (inner_iter == 3) {
                    break;
                } else {
                    let _dummy = 1u8;
                };

                if (outer_count == 2) {
                    break;
                } else {
                    let _dummy2 = 0u8;
                };
                
                inner_count = inner_count + 1;
            };

            if (outer_count == 3) {
                break;
            } else {
                let _dummy3 = 0u8;
            };
        };

        // Return the counts after loops to verify final values
        (outer_count, inner_count)
    }

    public fun runner() {
        let _ = max_product_four_consecutive();
        let _ = nested_loops_with_breaks();
    }
}

//# run 0xCAFE::ConsecutiveProduct::max_product_four_consecutive

//# run 0xCAFE::ConsecutiveProduct::nested_loops_with_breaks

//# run 0xCAFE::ConsecutiveProduct::runner

// Featurres:
// 90b0011045b6d2bb1a0407e441a41a35: Use if-else expressions for conditional branching.
// 27cb792f44578dcbc06e6a5cf848549a: Test that the function correctly finds the greatest product of four consecutive digits in a predefined vector of digits.
// fb975419e419545ebed8bc07190730ed: Test that nested loops with inner and outer breaks execute correctly and all variable assignments persist as expected after breaking out of both loops.
