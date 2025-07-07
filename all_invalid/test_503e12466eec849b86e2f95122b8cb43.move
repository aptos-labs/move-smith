//# publish
module 0xABC::IterationTest {
    use std::vector;

    // Reusable foreach function over a vector of any type, applying an action
    public inline fun foreach<X>(v: &vector<X>, action: |&X|) {
        let i = 0;
        while (i < vector::length(v)) {
            action(vector::borrow(v, i));
            i = i + 1;
        }
    }

    // Function that sums elements in a vector of u64 using foreach
    public fun sum_elements(v: vector<u64>): u64 {
        let total = 0;
        foreach<&u64>(&v, |e: &u64| {
            total = total + *e;
        });
        total
    }

    // Function that counts even numbers in the vector
    public fun count_evens(v: vector<u64>): u64 {
        let count = 0;
        foreach<&u64>(&v, |e: &u64| {
            if (*e % 2 == 0) {
                count = count + 1;
            }
        });
        count
    }

    // Function that transforms a vector by doubling each element and returns the new vector
    public fun double_elements(v: vector<u64>): vector<u64> {
        let result = vector::empty<u64>();
        foreach<&u64>(&v, |e: &u64| {
            vector::push_back(&mut result, *e * 2);
        });
        result
    }

    // Runner function to test iteration over a vector
    public fun run_tests() {
        let v = vector[4u64, 7, 2, 9, 6];

        let sum = sum_elements(v);
        // sum should be 4 + 7 + 2 + 9 + 6 = 28

        let evens = count_evens(v);
        // evens should be 3 (4, 2, 6)

        let doubled = double_elements(v);
        // doubled vector should be [8, 14, 4, 18, 12]

        // To verify, we can return a tuple of results
        // But assertions are to be ignored
        // Just expose the results
        (sum, evens, doubled)
    }
}

//# run 0xABC::IterationTest::run_tests