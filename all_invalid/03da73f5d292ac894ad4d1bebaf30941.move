//# publish
module 0xCAFE::FeatureTest {
    // Define a struct with some fields to test initialization and return logic
    struct Data has copy, drop {
        count: u64,
        total: u64,
    }

    // Function to initialize Data, increment count, sum total and return sum
    public fun test(): u64 {
        let data = Data { count: 0, total: 0 };
        // Increment count and add to total
        data.count = data.count + 1;
        data.total = data.total + data.count;
        // For demonstration, do a loop with variable scope
        let mut sum: u64 = 0; // Declare mut to allow reassignment
        let upper_bound: u64 = 5; // Initialize upper bound for scope
        let mut i: u64 = 0; // Declare i as mutable
        while (i < upper_bound) {
            sum = sum + i;
            i = i + 1;
        }
        // Add sum to total
        data.total = data.total + sum;
        // Return the sum of the two fields
        data.count + data.total
    }
}

//# run 0xCAFE::FeatureTest::test --signers 0xCAFE