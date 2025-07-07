//# publish
module 0x55::SumTest {
    use std::vector;

    // A generic foreach function that applies an action to each element of a vector
    public inline fun foreach<X>(v: &vector<X>, action: |&X|) {
        let i = 0;
        while (i < vector::length(v)) {
            action(vector::borrow(v, i));
            i = i + 1;
        }
    }

    // Function that sums all elements in a vector of u64 using the foreach
    public fun sum_elements(v: &vector<u64>): u64 {
        let total = 0;
        foreach<u64>(v, |e: &u64| total = total + *e);
        total
    }

    // Function that creates a vector, applies foreach to print each element (simulated here),
    // and returns the total sum
    public fun process_and_sum(): u64 {
        let values = vector[10u64, 20, 30, 40, 50];
        // In real tests, we might print or log, but here we'll just return sum
        sum_elements(&values)
    }

    // Function that tests nested foreach calls, to ensure correct iteration
    public fun nested_test(): u64 {
        let outer_vec = vector[1u64, 2, 3];
        let inner_vecs = vector[vector[1u64, 2], vector[3, 4]];

        let total: u64 = 0;

        // Outer foreach
        let mut total_outer = 0;
        foreach<vector<u64>>(&inner_vecs, |inner_v: &vector<u64>| {
            // Inner foreach
            foreach<u64>(inner_v, |e: &u64| {
                total_outer = total_outer + *e;
            });
        });

        total_outer
    }

    // Runner function to expose the tests
    public fun run_all_tests(): u64 {
        let sum1 = sum_elements(&vector[7u64, 8, 9]);
        let sum2 = process_and_sum();
        let sum3 = nested_test();
        // Sum all results for simplicity
        sum1 + sum2 + sum3
    }
}

//# run 0x55::SumTest::run_all_tests