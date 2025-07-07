//# publish
module 0x1::test_module {
    // Function to assign a value based on condition and return it
    public fun assign_value(cond: bool): u64 {
        let result: u64;
        if (cond) {
            result = 42;
        } else {
            result = 7;
        }
        result
    }

    // Runner function to test assign_value with both true and false
    public fun run_assignments() {
        let val_true = Self::assign_value(true);
        // Optionally, we can do something with val_true, e.g., store or check
        let val_false = Self::assign_value(false);
    }
}

module 0x1::spec_module {
    use std::spec_language::specification;

    // Specification to verify assign_value function
    #[spec]
    fun assign_value_spec(cond: bool): u64 {
        // The spec states that if cond is true, result is 42; else 7
        // Pureness checks, no side effects
        // We don't include this in runtime, only in spec
        if (cond) {
            42
        } else {
            7
        }
    }

    // Pseudo specify function for assign_value, for normal verification
    #[spec]
    fun verify_assign_value() {
        let cond: bool;
        // For pureness, check that the function adheres to the spec
        // No actual runtime code is needed here, just illustrative
        // The verification tool will check the implementation against specification
    }
}

//# run 0x1::test_module::run_assignments --signers 0x1