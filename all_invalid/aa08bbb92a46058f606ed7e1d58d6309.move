
//# publish
module 0xCAFE::NestedBlocks {
    use std::vector;

    struct Outer has copy, drop, store {
        a: u64,
        b: u64,
    }

    struct Inner {
        value: u64,
    }

    struct NamedVariant has copy, drop {
        name: vector<u8>,
        id: u8,
        detail: Inner,
    }

    public fun compute_sums(x: u64): u64 {
        let sum = 0;

        // Nested blocks with variable assignments and arithmetic
        {
            let first = {
                let temp = x + 5;
                temp * 2
            };

            let second = {
                let y = x * 3;
                let z = y + first;
                z - 1
            };

            sum = first + second;
        };

        // Final value of sum is returned
        sum
    }

    public fun tuple_and_reassignment_in_loop(): (u64, u64) {
        let total = 0u64;
        let last_value = 100u64;

        let values = vector[10u64, 20u64, 30u64];
        let i = 0u64;

        // Loop over vector length, reassignment and tuple unpacking inside
        while (i < 3) {
            let (increment, new_last) = (vector::borrow(&values, i as u64), last_value - 1);
            total = total + *increment;
            last_value = new_last;
            i = i + 1;
        };

        (total, last_value)
    }
}



//# run 0xCAFE::NestedBlocks::compute_sums --args 7u64



//# run 0xCAFE::NestedBlocks::tuple_and_reassignment_in_loop


// Features:
// 5dd5bb9af78300bbe8ee21a6bcd8fcf6: Test that the Move language correctly handles nested block expressions with variable assignments and arithmetic calculations within a single function.
// 0d49697b7af45dcb92e4c3f355a6c4cb: Define struct variants with named attributes, names, and fields.
// d5ebdda52ab03427ef0ad5a20f79171f: Test that variable reassignment and tuple unpacking inside a loop behave correctly and produce expected values after the loop completes.
