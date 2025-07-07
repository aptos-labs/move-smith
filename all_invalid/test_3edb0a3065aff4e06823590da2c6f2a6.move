//# publish
module 0xabcde::nested_functions {
    struct FuncStrict(|| | | u128) has copy, drop;

    fun get_constant(): u128 {
        12345678901234567890
    }

    public fun test_nested_functions(input_value: u128): vector<u128> {
        // Define a nested higher-order function
        let outer_closure: || || u128 = || {
            // Capture input_value
            let inner_closure: || u128 = || {
                input_value
            };
            // Return a closure that calls inner_closure + a constant
            || {
                let val = inner_closure();
                val + 1000
            }
        };
        // Invoke the outer closure twice, expecting same result
        let result1 = outer_closure()();
        let result2 = outer_closure()();

        // Define a more complex nested closure with different captures
        let nested_closure: || || u128 = || {
            let constant = get_constant();
            || {
                let val1 = input_value;
                let val2 = get_constant();
                // Sum both captures
                val1 + val2
            }
        };

        let sum_result = nested_closure()();

        // Define a FuncStrict encapsulating a closure capturing input_value
        let f: FuncStrict(|| || input_value) = FuncStrict(|| || input_value);

        // Call the stored function
        let f_result = f()();

        vector[ result1, result2, sum_result, f_result ]
    }
}
//# run 0xabcde::nested_functions::test_nested_functions --args 987654321987654321987654321
