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
        let max_index = length - 4;

        // We'll use two variables 'i' and 'max_product' and shadow them on each iteration
        let mut_i = 0;
        let mut_max_product = 0;

        max_product_loop(&digits, max_index, mut_i, mut_max_product)
    }

    // Helper function to implement loop with shadowed variables for max_product_four_consecutive
    fun max_product_loop(
        digits: &vector<u8>, 
        max_index: u64, 
        i: u64, 
        max_product: u64
    ): u64 {
        if (i > max_index) {
            max_product
        } else {
            let prod = product_of_four(digits, i);
            let new_max = if (prod > max_product) { prod } else { max_product };
            max_product_loop(digits, max_index, i + 1, new_max)
        }
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