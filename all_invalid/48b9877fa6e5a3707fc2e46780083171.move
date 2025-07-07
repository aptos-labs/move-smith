
//# publish
module 0xCAFE::TestSumAndUpdate {
    struct Accumulator has copy, drop {
        total: u64,
        count: u64,
    }

    // Function to sum decreasing values and accumulate results
    public fun test1(x: u64, y: u64): u64 {
        let x_local = x;
        let y_local = y;
        let acc = Accumulator { total: 0, count: 0 };

        while (x_local > 0 && y_local > 0) {
            acc = Accumulator { total: acc.total + x_local + y_local, count: acc.count + 1 };
            x_local = x_local - 1;
            y_local = y_local - 1;
        };
        acc.total + x + y
    }

    // Test assigning new value to a local variable and returning it
    public fun test2(val: u64): u64 {
        let local_val = val;
        local_val = local_val + 42;
        local_val
    }

    spec module {
        spec test1 {
            Update acc.total = acc.total + x_local + y_local;
            Update acc.count = acc.count + 1;
            Update x_local = x_local - 1;
            Update y_local = y_local - 1;
        }
    }
}


//# run 0xCAFE::TestSumAndUpdate::test1 --args 5u64 3u64


//# run 0xCAFE::TestSumAndUpdate::test2 --args 10u64


// Featurres:
// 46dad5b78645bcbf204e23b9432b614a: Test that the `test1` function correctly sums decreasing values from the input and computes the final result as the sum of initial inputs plus the accumulated total.
// cbbb2abb9b13eae9eec5a0699370e467: Test that assigning a new value to a local variable updates its value correctly before returning it.
// 4d125703dbd27e6cbbd9dd2975332172: Specify update expressions within spec blocks using 'Update' with a right-hand side expression.
