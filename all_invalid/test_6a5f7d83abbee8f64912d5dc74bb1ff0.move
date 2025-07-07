//# publish
module 0xA11CE::LambdaSerialization {
    use std::bcs;

    // A function to test nested lambdas with serialization
    public fun deep_lambda_test(): bool {
        let outer_x = 5;
        let outer_y = 3;

        // Deeply nested lambda returning sum of captured variables
        let nested_f: || || || u64 has drop = || || || {
            // Capture outer variables
            outer_x + outer_y
        };

        // Another lambda with same logic
        let nested_g: || || || u64 has drop = || || || {
            outer_x + outer_y
        };

        // Serialize both lambdas
        let bytes_f = bcs::to_bytes(&nested_f);
        let bytes_g = bcs::to_bytes(&nested_g);

        // Compare serialized forms
        bytes_f == bytes_g
    }

    // Function to test higher-order passing of lambdas combined with byte serialization
    public fun higher_order_lambda_test(x: u64): bool {
        // Build nested lambdas that produce multiple layers
        let f_outer: || || u64 has drop = || {
            let f_inner: || u64 has drop = || {
                x + 10
            };
            f_inner()
        };

        let g_outer: || || u64 has drop = || {
            let g_inner: || u64 has drop = || {
                x + 10
            };
            g_inner()
        };

        // Serialize outer lambdas
        let bytes_f = bcs::to_bytes(&f_outer);
        let bytes_g = bcs::to_bytes(&g_outer);

        // Confirm serialized form equality
        bytes_f == bytes_g
    }
}

//# run 0xA11CE::LambdaSerialization::deep_lambda_test
//# run 0xA11CE::LambdaSerialization::higher_order_lambda_test --args 42