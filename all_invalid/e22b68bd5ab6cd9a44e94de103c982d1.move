//# publish
module 0x1::test_module {
    use std::option;

    /// Helper function to demonstrate optional type annotations
    public fun pick_value(condition: bool): option<u64> {
        if (condition) {
            // Assign a value within if branch with optional annotation
            let v: option<u64> = option::some(42);
            v
        } else {
            // Assign None in else branch
            option::none()
        }
    }

    /// Function with specification checks and ability constraints
    /// This function checks that a provided value is less than max_value
    /// and that type parameter T has the key ability.
    public fun check_value_with_spec_and_constraints<T: copy + drop + store>(
        value: T,
        max_value: T
    ) acquires T {
        // Specification: ensure value <= max_value
        // (assuming T supports comparison, which is a constraint for demonstration)
        assert!(value <= max_value, 0); 
    }

    /// A function that demonstrates parsing type constraints
    public fun parse_type_constraints_example<T: copy + drop + store>() {
        // Function does nothing but is used to test constraints
    }

    /// Runner to test pick_value function
    public fun run_pick_value() {
        let result_some = pick_value(true);
        let result_none = pick_value(false);
        // This runner can be extended for assertion if needed
    }
}

//# run 0x1::test_module::run_pick_value --signers 0x1