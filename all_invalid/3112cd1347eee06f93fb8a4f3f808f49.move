//# publish
module 0xCAFE::ExprBinaryOps {
    use std::vector;

    // Store experiments in a keyset (set of vector<u8>)
    struct Experiments has store, key {
        experiments: vector<vector<u8>>,
    }

    public fun create_experiments(): Experiments {
        // Create a keyset with two experiments: "exp1" and "exp2"
        let exp1 = b"exp1";
        let exp2 = b"exp2";
        let exps = vector::empty<vector<u8>>();
        vector::push_back(&mut exps, copy exp1);
        vector::push_back(&mut exps, copy exp2);
        Experiments { experiments: exps }
    }

    // Function to check if an experiment is in the experiments (keyset) vector
    public fun has_experiment(experiments: &Experiments, experiment: &vector<u8>): bool {
        let mut i = 0;
        while (i < vector::length(&experiments.experiments)) {
            if (vector::length(&experiment) == vector::length(&vector::borrow(&experiments.experiments, i))) {
                let mut j = 0;
                let mut all_equal = true;
                while (j < vector::length(experiment) && all_equal) {
                    if (*vector::borrow(experiment, j) != *vector::borrow(&vector::borrow(&experiments.experiments, i), j)) {
                        all_equal = false;
                    }
                    j = j + 1;
                }
                if (all_equal) {
                    return true;
                }
            }
            i = i + 1;
        }
        false
    }

    // Use binary operators with correct precedence: 
    // Expression: 1 + 2 * 3 - 4 / 2 % 2 & 3 ^ 1 | 0
    // Precedence: * / % > + - > & > ^ > |
    public fun binary_expression(): u64 {
        let val = 1u64 + 2u64 * 3u64 - 4u64 / 2u64 % 2u64 & 3u64 ^ 1u64 | 0u64;
        val
    }

    // Function to declare an experiment only if present
    public fun declare_experiment(
        experiments: &Experiments, 
        experiment: vector<u8>
    ): bool {
        if (has_experiment(experiments, &experiment)) {
            // Experiment recognized, "declared"
            true
        } else {
            // Not recognized
            false
        }
    }

    // Runner function to test above functionalities
    public fun runner(): bool {
        let exps = create_experiments();
        let bin_result = binary_expression();
        // bin_result should be u64, let's add a dummy check (we omit assertions)
        // Test declare_experiment with "exp1" (exists)
        let exp1 = b"exp1";
        let ok1 = declare_experiment(&exps, copy exp1);
        // Test declare_experiment with "exp3" (not exists)
        let exp3 = b"exp3";
        let ok2 = declare_experiment(&exps, copy exp3);
        ok1 && !ok2
    }
}
//# run 0xCAFE::ExprBinaryOps::runner

// Featurres:
// 57919bd46e68fd73db04e28e80162320: Use binary operators with correct precedence during expression parsing.
// 50491a6bc8926e957907e98af5cd840d: Write number literals for integer and numeric values within the allowable size for their type.
// 7ff5ffab68f220359ee26d0b51fc1a96: Declare an experiment in the list only if it is present in the `EXPERIMENTS` keyset, ensuring only recognized experiments are used.
