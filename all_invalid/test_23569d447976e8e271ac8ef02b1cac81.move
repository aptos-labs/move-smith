//# publish
module 0x42::Test {
    use std::vector;

    // Reuse the foreach function to demonstrate iteration over u64 and conditional sum
    public inline fun foreach<X>(v: &vector<X>, action: |&X|) {
        let i = 0;
        while (i < vector::length(v)) {
            action(vector::borrow(v, i));
            i = i + 1;
        }
    }

    // Demonstrate iteration over a vector of u64 and collect the total of even numbers only
    public fun sum_evens(): u64 {
        let v = vector[4u64, 7, 10, 3, 8];
        let total_even = 0;
        foreach<u64>(&v, |e: &u64| {
            if (*e % 2 == 0) {
                total_even = total_even + *e;
            }
        });
        total_even
    }

    // A helper function to sum all elements in a vector of u64
    public fun sum_all_elements(): u64 {
        let v = vector[5u64, 15, 25, 35, 45];
        let total = 0;
        foreach<u64>(&v, |e: &u64| total = total + *e);
        total
    }

    // Test that the foreach correctly accumulates the sum over both even and odd elements
    public fun test_combined(): u64 {
        let v = vector[1u64, 2, 3, 4, 5];
        let sum = 0;
        // Sum all elements
        foreach<u64>(&v, |e: &u64| sum = sum + *e);
        sum
    }
}

//# run 0x42::Test::sum_evens
//# run 0x42::Test::sum_all_elements
//# run 0x42::Test::test_combined