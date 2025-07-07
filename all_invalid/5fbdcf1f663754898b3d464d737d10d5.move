// Testing Attach specifications to a script, checking experiment declaration presence, and sequence of statements.

//# publish
module 0xCAFE::ExperimentManager {
    use std::vector;

    /// List of approved experiments.
    const EXPERIMENTS: vector<vector<u8>> = vector[
        b"teleport",
        b"fusion",
        b"gravity"
    ];

    public fun is_in_experiments(name: &vector<u8>): bool {
        let experiments = &Self::EXPERIMENTS;
        let i = 0;
        let len = vector::length(experiments);
        let mut idx = i;
        while (idx < len) {
            if (*vector::borrow(experiments, idx) == *name) {
                return true;
            };
            idx = idx + 1;
        };
        false
    }

    /// Only add experiment if name is in EXPERIMENTS. Returns true if added.
    public fun try_register_experiment(
        list: &mut vector<vector<u8>>,
        name: vector<u8>,
    ): bool {
        if (!Self::is_in_experiments(&name)) {
            false
        } else {
            vector::push_back(list, name);
            true
        }
    }

    /// Demo runner to call from outside: tries both a good and bad experiment,
    /// returns (bool, bool)
    public fun runner(): (bool, bool) {
        let experiments = vector::empty<vector<u8>>();
        let mut exp_list = experiments;
        let good = b"teleport";
        let bad = b"unknown";
        let ok_added = Self::try_register_experiment(&mut exp_list, copy good);
        let bad_added = Self::try_register_experiment(&mut exp_list, copy bad);
        (ok_added, bad_added)
    }
}

//# run 0xCAFE::ExperimentManager::runner

//# run
script {
    use std::vector;
    use 0xCAFE::ExperimentManager;

    /// Attach Specifications:
    /// ensures result: is_in_experiments(experiment) ==> added;
    /// ensures !is_in_experiments(experiment) ==> !added;
    fun main() {
        // Sequence of variable declarations, bindings, and expressions
        let attempted: vector<vector<u8>> = vector::empty<vector<u8>>();
        let mut attempted_experiments = attempted;
        let exp1 = b"fusion";
        let exp2 = b"blaster"; // Not in EXPERIMENTS

        let added1 = ExperimentManager::try_register_experiment(&mut attempted_experiments, copy exp1);
        let added2 = ExperimentManager::try_register_experiment(&mut attempted_experiments, copy exp2);

        // Update/modify a variable
        let total_attempted = vector::length(&attempted_experiments);

        // Expression binding
        let (res1, res2) = (added1, added2);

        // Just to ensure all local values are used...
        let _ = total_attempted + 0;

        // This script verifies specification/ensures for script execution
        // but no assertion code is written, per instructions.
    }
}

// Featurres:
// 916e7988631e0eda4f4ef5f6ecc5844b: Attach specifications to a script for additional assertions or requirements.
// 7ff5ffab68f220359ee26d0b51fc1a96: Declare an experiment in the list only if it is present in the `EXPERIMENTS` keyset, ensuring only recognized experiments are used.
// 20213dca0846ac42ca0c49cb1fcfaa1c: Write statement sequences consisting of variable declarations, bindings, and expressions in function bodies.