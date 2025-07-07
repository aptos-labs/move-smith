
//# publish
module 0xCAFE::QuantifierTest {
    use std::vector;

    // A simple struct to hold u8 values
    struct Item has copy, drop, store {
        val: u8,
    }

    // Create a vector containing Items from 0..n-1
    public fun create_items(n: u8): vector<Item> {
        let v = vector::empty<Item>();
        let i = 0u8;
        while (i < n) {
            let item = Item { val: i };
            vector::push_back(&mut v, item);
            i = i + 1;
        };
        v
    }

    // Check if there exists an item with val == x in vector v
    public fun exists_val(v: &vector<Item>, x: u8): bool {
        let len = vector::length(v);
        let i = 0u64;
        let res = false;
        while (i < len) {
            if (vector::borrow(v, i).val == x) {
                res = true;
                break;
            };
            i = i + 1;
        };
        res
    }

    // Check whether all items' val < limit
    public fun forall_lt(v: &vector<Item>, limit: u8): bool {
        let len = vector::length(v);
        let i = 0u64;
        let res = true;
        while (i < len) {
            if (!(vector::borrow(v, i).val < limit)) {
                res = false;
                break;
            };
            i = i + 1;
        };
        res
    }

    // Using choose to find the first item with val == x or abort
    public fun choose_val(v: &vector<Item>, x: u8): u64 {
        let len = vector::length(v);
        let i = 0u64;
        while (i < len) {
            if (vector::borrow(v, i).val == x) {
                return i;
            };
            i = i + 1;
        };
        // Abort with code 999 if not found
        abort 999;
    }

    // A function that proves some property using quantifiers in assert specs
    public fun test_quantifiers(n: u8, x: u8, limit: u8) {
        let v = create_items(n);

        // Assert exists quantifier: some item in v is equal to x if x < n
        assert!(!((x < n) ^ exists_val(&v, x)), 1000);

        // Assert forall quantifier: all items have val less than n
        assert!(forall_lt(&v, n), 1001);

        // Choose index of x in v if x < n
        if (x < n) {
            let _idx = choose_val(&v, x);
        };
    }

    // Runner function for zero arguments to ease testing
    public fun runner() {
        test_quantifiers(10u8, 5u8, 10u8);
        test_quantifiers(20u8, 19u8, 20u8);
        test_quantifiers(15u8, 16u8, 15u8);
    }
}



//# run 0xCAFE::QuantifierTest::runner
