
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
        // In Move, nested functions are not allowed. Instead, define inner_function externally or simulate inline.
        // Since nested functions are invalid, we move it outside or simulate the logic inline.

        // Simulate calling inner_function with true
        let res_true = {
            // Inline logic of inner_function(true)
            let flag = true;
            if (flag) {
                // Reachable code
                let _reachable_var = 42u8;
            } else {
                // Unreachable code if called with false
                let _unreachable_var = 99u8;
            };
            flag
        };

        // Simulate calling inner_function with false
        let res_false = {
            // Inline logic of inner_function(false)
            let flag = false;
            if (flag) {
                let _reachable_var = 42u8;
            } else {
                let _unreachable_var = 99u8;
            };
            flag
        };

        // Construct location metadata similar to previous code
        let locations: vector<(u64, u64)> = vector![
            (0, 10), // Entry point
            (11, 20), // 'if' branch
            (21, 30), // 'else' branch
            (31, 40), // End
        ];

        // Dummy bytecode
        let bytecode: vector<u8> = vector![1, 2, 3, 4, 5];

        // Dummy metadata
        let metadata: vector<u8> = vector![10, 20, 30];

        // Construct function data
        let func_data = construct_function_data(bytecode, metadata, locations);

        // No further assertions, just simulating usage
    }
}


//# run 0xBADD::TestCompilerVMFeatures::test_unreachable_and_unused

// Features:
// 32cbfe9c2cdcffb99be90146335577ad: Construct and return the FunctionData structure containing all relevant bytecode and metadata.
// 43c7fcce2bde52d945dfe5e725a926b9: Determine if a specific location in a function is definitely unreachable or potentially reachable during control flow analysis
// c27969d4f35a7486332f9ed9bcca96fc: Check for assignments to local variables that are never used.
