//# publish
module 0xCAFE::ParserModule {
    use std::vector;

    /// Parses items from a byte vector using a custom continuation predicate and item parser functions.
    public fun parse_items(
        input: vector<u8>,
        cont: |u8| bool,
        parse_item: |vector<u8>, u64| (u8, u64)
    ): vector<u8> {
        let mut pos = 0u64;
        let mut results = vector::empty<u8>();
        while (pos < vector::length(&input) as u64 && cont(vector::borrow(&input, pos as u64))) {
            let (item, next_pos) = parse_item(input, pos);
            vector::push_back(&mut results, item);
            pos = next_pos;
        };
        results
    }

    /// Continuation function: continue as long as the byte is not zero.
    public fun cont_non_zero(b: u8): bool {
        b != 0u8
    }

    /// Item parser: parse one byte item at position pos.
    public fun parse_one(input: vector<u8>, pos: u64): (u8, u64) {
        let item = *vector::borrow(&input, pos);
        (item, pos + 1)
    }

    /// Item parser: parse byte and skip next byte (simulate variable length).
    public fun parse_and_skip(input: vector<u8>, pos: u64): (u8, u64) {
        let item = *vector::borrow(&input, pos);
        let next_pos = pos + 2;
        (item, next_pos)
    }

    /// Runner function to test parse_items with cont_non_zero and parse_one
    public fun run_parse_simple() {
        let input = vector[1u8, 2u8, 3u8, 0u8, 4u8, 5u8];
        let results = parse_items(input, cont_non_zero, parse_one);
        // results should contain 1, 2, 3
        vector::length(&results);
    }

    /// Runner function to test parse_items with parse_and_skip
    public fun run_parse_skip() {
        let input = vector[10u8, 99u8, 20u8, 99u8, 30u8, 0u8];
        let results = parse_items(input, cont_non_zero, parse_and_skip);
        // results should contain 10, 20, 30
        vector::length(&results);
    }

    /// Test function to access vector elements by index (square bracket syntax)
    public fun test_indexing() {
        let arr = vector[7u8, 8u8, 9u8];
        let first = arr[0];
        let second = arr[1];
        let third = arr[2];
        let sum = first + second + third;
        sum
    }
}

//# run 0xCAFE::ParserModule::run_parse_simple

//# run 0xCAFE::ParserModule::run_parse_skip

//# run 0xCAFE::ParserModule::test_indexing

// Featurres:
// bf49700cf955331be956ada40e195684: Create functions that parse lists of items with customizable continuation and item parsing logic.
// b612228231af0ec395407363e8b1cefc: Set function body with a block of code representing the function's implementation.
// d10170f11072e2d9acf613df74d7a866: Index into collections or arrays using square brackets (e.g., `collection[index]`).
