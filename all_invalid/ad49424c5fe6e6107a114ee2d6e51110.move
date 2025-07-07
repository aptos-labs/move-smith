
//# publish
module 0xDEAD::FeatureTest {
    // You NEVER try to use this 0xDEAD::FeatureTest
    // It is only an example

    use std::signer;
    use std::vector;

    // Specification annotations (simulated via comments, as Move does not support native spec annotations)
    // @spec fn process_input(data: vector<u8>) -> bool;

    public fun process_input(data: vector<u8>): bool {
        // Example processing: check if data contains byte 'a' (0x61)
        let contains_a = false;
        let len = vector::length(&data);
        let i = 0;
        while (i < len) {
            let byte = *vector::borrow(&data, i);
            if (byte == 0x61) {
                contains_a = true;
                break;
            };
            i = i + 1;
        };
        contains_a
    }

    // Specification for function
    // @spec fn compute_with_branch(input: vector<u8>) -> (bool, bool);
    public fun compute_with_branch(input: vector<u8>): (bool, bool) {
        let data_contains_a = process_input(input);
        let result: bool;
        if (data_contains_a) {
            // When data contains 'a', run an infinite loop with a break
            let counter = 0u64;
            loop {
                // simulate some work
                counter = counter + 1;
                if (counter >= 10) {
                    break;
                };
            };
            result = true;
        } else {
            result = false;
        };
        // Return a tuple indicating whether 'a' was found and if loop executed
        (data_contains_a, result)
    }

    // Function to generate byte string literal for testing
    public fun generate_input_with_a(): vector<u8> {
        vector::empty<u8>()
        |>
        |(vector::push_back(&mut, 0x62))
        |(vector::push_back(&mut, 0x61))
        |(vector::push_back(&mut, 0x63))
        |(vector::push_back(&mut, 0x64))
    }

    public fun generate_input_without_a(): vector<u8> {
        vector::empty<u8>()
        |>
        |(vector::push_back(&mut, 0x62))
        |(vector::push_back(&mut, 0x63))
        |(vector::push_back(&mut, 0x64))
    }

    // Runner functions for testing different inputs
    public fun test_with_a(): (bool, bool) {
        let input = generate_input_with_a();
        compute_with_branch(input)
    }

    public fun test_without_a(): (bool, bool) {
        let input = generate_input_without_a();
        compute_with_branch(input)
    }
}


//# run 0xDEAD::FeatureTest::test_with_a --signers 0xBADD

//# run 0xDEAD::FeatureTest::test_without_a --signers 0xBADD


// Featurres:
// abb904b383714669901a81661b8dfd69: Use byte string literals for representing byte string data.
// e21c2311d71aed9b099d9976f106e805: Test that a conditional branch with an infinite loop containing a break statement executes correctly without causing deadlock or unintended behavior.
// e503ac8923db8e280a41f115de02ceb4: Attach specification blocks to individual module members (such as functions) and optionally provide their signatures for precise specification.
