
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Function to find the greatest product of four consecutive digits in a vector
    public fun max_consecutive_product(digits: vector<u8>): u32 {
        let length = vector::length(&digits);
        let max_product = 0u32;
        let i = 0;
        while (i <= length - 4) {
            let product = 1u32;
            let j = 0;
            while (j < 4) {
                product = product * (vector::borrow(&digits, i + j) as u32);
                j = j + 1;
            };
            if (product > max_product) {
                max_product = product;
            };
            i = i + 1;
        };
        max_product
    }

    // init function that processes empty key and value vectors
    public fun init(keys: vector<u64>, values: vector<bool>): (vector<u64>, vector<bool>) {
        // For testing, just return the input vectors (which are possibly empty)
        // but simulate some processing to exercise the code
        let new_keys = if (vector::length(&keys) == 0) {
            vector::empty<u64>()
        } else {
            vector::clone(&keys)
        };
        let new_values = if (vector::length(&values) == 0) {
            vector::empty<bool>()
        } else {
            vector::clone(&values)
        };
        (new_keys, new_values)
    }

    // maybe function to implement the first test scenario
    public fun maybe_find_max_product(): u32 {
        // predefined vector of digits, e.g., [7,3,1,2,8,2,8,1,8,6,7,8,1,3,3,0,4,4,2,8]
        let digits = vector::pack_all([7u8, 3u8, 1u8, 2u8, 8u8, 2u8, 8u8, 1u8, 8u8, 6u8, 7u8, 8u8, 1u8, 3u8, 3u8, 0u8, 4u8, 4u8, 2u8, 8u8]);
        max_consecutive_product(digits)
    }

    // maybe function to implement the second test scenario
    public fun maybe_init_empty_vectors(): bool {
        let (keys, values) = init(vector::empty<u64>(), vector::empty<bool>());
        // Validate that the returned vectors are empty
        vector::length(&keys) == 0 && vector::length(&values) == 0
    }
}


//# run 0xCAFE::TestModule::maybe_find_max_product

//# run 0xCAFE::TestModule::maybe_init_empty_vectors

// Featurres:
// 27cb792f44578dcbc06e6a5cf848549a: Test that the function correctly finds the greatest product of four consecutive digits in a predefined vector of digits.
// ab5f38c45010be35b1b342bc6cd4b471: Test that the `init` function successfully maps over empty key and value vectors, computing new vectors without errors.
// 6ac40e2768f98e344e03664055e8314d: Use 'maybe' as an indication that a code segment may be reachable.
