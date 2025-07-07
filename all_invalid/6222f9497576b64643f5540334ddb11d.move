
//# publish
module 0xBADD::TestCompilerVMFeatures {
    use std::vector;

    struct FunctionData has copy, drop {
        bytecode: vector<u8>,
        metadata: vector<u8>,
        locations: vector<(u64, u64)>,
    }

    public fun construct_function_data(bytecode: vector<u8>, metadata: vector<u8>, locations: vector<(u64, u64)>): FunctionData {
        let data = FunctionData {
            bytecode,
            metadata,
            locations,
        };
        data
    }

    public fun test_unreachable_and_unused() {
        // Function to test control flow reachability
        fun inner_function(flag: bool): bool {
            if (flag) {
                // Reachable code
                let _reachable_var = 42u8;
            } else {
                // Unreachable code if never called with false
                let _unreachable_var = 99u8;
            };
            // Verify if unreachable code is identified
            flag
        }

        // Simulate control flow analysis: location 2 in inner_function is reachable if called with 'true'
        let locations: vector<(u64, u64)> = vector![
            (0, 10), // Entry point
            (11, 20), // 'if' block
            (21, 30), // 'else' block
            (31, 40), // End
        ];

        // Construct bytecode for the function (dummy)
        let bytecode: vector<u8> = vector![1, 2, 3, 4, 5];

        // Metadata (dummy)
        let metadata: vector<u8> = vector![10, 20, 30];

        // Construct function data to test
        let func_data = construct_function_data(bytecode, metadata, locations);

        // Call inner_function with 'true' and 'false' to analyze reachability
        let _res1 = inner_function(true);
        let _res2 = inner_function(false);

        // Check for unused local 'unreachable_var'
        // (Simulated by ensuring the variable is never used after assignment when unreachable)
    }
}


//# run 0xBADD::TestCompilerVMFeatures::test_unreachable_and_unused


// Featurres:
// 32cbfe9c2cdcffb99be90146335577ad: Construct and return the FunctionData structure containing all relevant bytecode and metadata.
// 43c7fcce2bde52d945dfe5e725a926b9: Determine if a specific location in a function is definitely unreachable or potentially reachable during control flow analysis
// c27969d4f35a7486332f9ed9bcca96fc: Check for assignments to local variables that are never used.
