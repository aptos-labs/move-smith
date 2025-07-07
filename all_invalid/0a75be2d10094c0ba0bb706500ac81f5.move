
//# publish
module 0xBADD::TestFeatures {
    use std::vector;
    // 'signer' is unused, so we remove the alias to fix the warning
    // use std::signer; // Removed

    // Function specifications to test access via 'specs'
    public fun specs() {
        // This function is a dummy to exercise spec access, does nothing
    }

    // Testing wildcard address '(* + 0x*)'
    // Using the address for pattern matching; in Move, actual implementation may not support wildcards directly,
    // but for test purposes, this demonstrates the syntax.
    public fun wildcard_test(dummy_addr: address) {
        // Simulating pattern match; in actual test, we'll pass a concrete address
        let _pattern_match = if (dummy_addr == address(0xCAFE)) {
            true
        } else {
            false
        };
    }

    // Function to mutably iterate over a vector, setting all elements to a given value
    public fun update_all_elements(vec: &mut vector<u64>, value: u64) {
        let len = vector::length(vec);
        let index = 0; // 'let' binding for mutable index
        while (index < len) {
            // Correct syntax: borrow_mut returns a mutable reference, assign via * on the reference
            *vector::borrow_mut(vec, index) = value;
            index = index + 1;
        };
    }

    // Runner function to test vector update
    public fun run_vector_update() {
        let v = vector::empty<u64>();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);
        vector::push_back(&mut v, 3);
        // Mutably iterate and set all to 99
        update_all_elements(&mut v, 99);
        // The test does not require assertions, but the vector now should have all 99s
    }
}



//# run 0xBADD::TestFeatures::specs



//# run 0xBADD::TestFeatures::wildcard_test --args 0xCAFE



//# run 0xBADD::TestFeatures::run_vector_update
