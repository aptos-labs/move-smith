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
        let sum: u64 = 0;
        let upper_bound: u64 = 5; // Initialize upper bound for scope
        let i = 0;
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

// Featurres:
// 10c39196ee09f2fb225b8a6872499049: Test that the `test` function correctly initializes a struct with incremented field values and returns their sum.
// 445fcdebe264ed16869a4233b4dfc04e: Configure the compiler to include backtrace information during errors by setting the 'MVC_BACKTRACE_ENV_VAR' environment variable.
// 79229d3feaaa54f543a0b3e6a9ccca09: Declare and initialize an upper bound value variable within the 'for' loop scope.
