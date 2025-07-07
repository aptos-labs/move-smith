
//# publish
module 0xCAFE::QuantifiedTest {
    use std::vector;
    use std::signer;

    struct Item has key, store {
        value: u8,
    }

    // Store an Item resource at signer's address
    public fun store_item(s: signer, val: u8) {
        let item = Item { value: val };
        move_to<Item>(&s, item);
    }

    // Function to check existence of Item with value > threshold using 'exists'
    public fun item_exists_above(threshold: u8): bool acquires Item {
        exists<Item>(@0xBEEF) &&
        // Check if Item.value > threshold
        let item_ref = borrow_global<Item>(@0xBEEF);
        item_ref.value > threshold
    }

    // Function to check if any Item resource exists at address 0xBEEF satisfying predicate
    // Using an explicit lambda promoted to top-level private function by compiler
    public fun check_item_exists_with_pred(): bool acquires Item {
        exists<Item>(@0xBEEF) && _is_value_even(@0xBEEF)
    }

    // Private function promoted from lambda: checks if Item.value at addr is even
    fun _is_value_even(addr: address): bool acquires Item {
        let item_ref = borrow_global<Item>(addr);
        let val = item_ref.value;
        (val % 2 == 0)
    }

    // Function using byte string literals
    public fun check_byte_strings(): vector<u8> {
        // Literal byte strings with b"" and x""
        let bs1: vector<u8> = b"quantified\nexists";
        let bs2: vector<u8> = x"CAFEBABE";
        // Concatenate bs1 and bs2 manually
        let concatenated = vector::empty<u8>();
        // push bs1 bytes
        let len1 = vector::length(&bs1);
        let i = 0;
        while (i < len1) {
            vector::push_back(&mut concatenated, *vector::borrow(&bs1, i));
            i = i + 1;
        };
        let len2 = vector::length(&bs2);
        i = 0;
        while (i < len2) {
            vector::push_back(&mut concatenated, *vector::borrow(&bs2, i));
            i = i + 1;
        };
        concatenated
    }
}


//# run 0xCAFE::QuantifiedTest::store_item --signers 0xBEEF --args 7u8


//# run 0xCAFE::QuantifiedTest::item_exists_above --args 5u8


//# run 0xCAFE::QuantifiedTest::check_item_exists_with_pred


//# run 0xCAFE::QuantifiedTest::check_byte_strings


// Featurres:
// 8c40c9a20785827b77fc8c0e29cf70ca: Write quantified expressions using 'exists' to assert the existence of values satisfying a condition.
// 68077687b42f75f155e9d5eb21717b87: Have the compiler automatically promote lambda expressions enclosed in functions or specs to top-level (module scope) private functions, so that lambdas behave as first-class closures.
// 57e2fb9f349faed7c5d21313d52c4dbe: Write literal byte strings using the byte string syntax in code.
