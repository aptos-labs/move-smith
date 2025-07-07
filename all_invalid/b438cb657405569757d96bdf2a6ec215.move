//# publish
module 0xCAFE::MixPureAndWrite {
    // Removed unused 'signer' alias

    struct Data has store, key {
        val: u64,
    }

    /// This function only reads on-chain resource, thus it is not 'pure'.
    public fun reads_data(addr: address): u64 acquires Data {
        let data_ref = borrow_global<Data>(addr);
        data_ref.val
    }

    /// This function is pure, it neither reads nor writes storage.
    public fun pure_add(x: u64, y: u64): u64 {
        x + y
    }

    // Mixing 'pure' attribute with 'acquires' is disallowed.
    // So this function cannot be pure if it uses acquires or storage access.
    // To fix, just remove the 'pure' keyword if it existed, or separate logic.

    // Note: The commented-out code is fine as-is for demonstration, so no change needed here.
}

//# publish
module 0xCAFE::Parser {
    use std::vector;

    /// Parses a vector of u8 items with a customizable continuation check and item parsing functions.
    /// continuation: |u8|bool  - returns true to continue parsing
    /// item_parser: |u8|u64 - parses individual item
    public fun parse_items_with_continuation(
        items: vector<u8>,
        continuation: &fun(u8): bool,
        item_parser: &fun(u8): u64
    ): vector<u64> {
        let mut parsed = vector::empty<u64>();
        let len = vector::length(&items);
        let mut idx = 0u64;
        while (idx < len) {
            let item = *vector::borrow(&items, idx);
            if (!(*continuation)(item)) {
                break;
            };
            let parsed_val = (*item_parser)(item);
            vector::push_back(&mut parsed, parsed_val);
            idx = idx + 1;
        };
        parsed
    }

    /// Example continuation that continues if item is less than 5
    public fun cont_example(x: u8): bool {
        x < 5
    }

    /// Example item parser that returns square of item as u64
    public fun item_parser_example(x: u8): u64 {
        let xx = x as u64;
        xx * xx
    }
}

//# publish
module 0xCAFE::WithSpec {
    // Removed unused 'signer' alias
    use std::signer;

    struct SpecStruct has key, store {
        val: u64,
    }

    /// #aborts_if val > 100;
    public fun create_spec_struct(s: signer, val: u64) {
        // Removed unnecessary 'acquires SpecStruct' annotation since 'move_to' automatically requires key but annotation's unnecessary
        assert!(val <= 100, 1);
        let obj = SpecStruct { val };
        move_to<SpecStruct>(&s, obj);
    }

    /// #specification snippet of checking value
    public fun value_okay(val: u64): bool {
        val <= 100
    }
}

//# run 0xCAFE::MixPureAndWrite::pure_add --args 10u64 20u64

//# run 0xCAFE::MixPureAndWrite::reads_data --args 0xBEEF

//# run 0xCAFE::Parser::parse_items_with_continuation --args vector[1u8,2u8,3u8,6u8,1u8]

//# run 0xCAFE::Parser::cont_example --args 4u8

//# run 0xCAFE::Parser::item_parser_example --args 7u8

//# run 0xCAFE::WithSpec::create_spec_struct --signers 0xBEEF --args 75u64

//# run 0xCAFE::WithSpec::value_okay --args 101u64