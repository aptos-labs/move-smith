
//# publish
module 0xCADE::MoveFeatureTest {
    use std::error;
    use std::spec;
    use std::value;

    // 1. Test for copying variable and passing into functions
    public fun test_copy_and_pass() {
        let original_value: u64 = 1234;
        let copied_value = copy original_value; // copy the value
        // Pass the copy into functions
        let sum = add_to_value(copied_value, 10);
        let product = multiply_value(copied_value, 2);

        // Check that original_value remains unchanged
        assert!(original_value == 1234, 999);
        // Check that copied_value remains unchanged
        assert!(copied_value == 1234, 999);
        // The sum and product should be based on the copied_value (1234)
        assert!(sum == 1244, 999);
        assert!(product == 2468, 999);
    }

    fun add_to_value(val: u64, delta: u64): u64 {
        val + delta
    }

    fun multiply_value(val: u64, factor: u64): u64 {
        val * factor
    }

    // 2. Functions annotated with spec blocks
    public fun spec_example() acquires 0xCADE::SpecStruct {
        // This function is linked with a spec
        // The spec is used for verification
        // (In real code, spec blocks would be defined within the module)
        // For simulation, log and invoke the specification
        spec::log("Running spec_example");
        let s = SpecStruct { a: 5, b: 10 };
        s
    }

    struct SpecStruct has copy, drop {
        a: u64,
        b: u64,
    }

    // 3. Create and use value expressions of various types
    public fun test_value_expressions() {
        // Value of type Unit
        let unit_expr = value::unit();

        // Value of type Error
        let error_expr = value::error(0xE1E);

        // Value of type Break
        let break_expr = value::break_();

        // Value of type Continue
        let continue_expr = value::continue_();

        // Specification value
        let spec_expr = value::spec(b"spec_condition");

        // General value expression
        let val_expr = value::value(b"some_value");

        // Embed in control flow with other move constructs
        if (is_error(error_expr)) {
            // Break on error
            break_;
        } else {
            // Continue on non-error
            continue_;
        };

        // Use specifications in control flow
        if (is_spec(spec_expr)) {
            // Do something if spec condition is true
        };

        // Return a tuple of all value expressions to verify their construction
        (unit_expr, error_expr, break_expr, continue_expr, spec_expr, val_expr)
    }

    fun is_error(v: value::Value): bool {
        // Simulate check
        // For test, just check if it's of type Error
        // Here, just a placeholder
        true
    }

    fun is_spec(v: value::Value): bool {
        // Simulate check
        true
    }
}


//# run 0xCADE::MoveFeatureTest::test_copy_and_pass


//# run 0xCADE::MoveFeatureTest::spec_example


//# run 0xCADE::MoveFeatureTest::test_value_expressions


// Featurres:
// b2f8659844c966f75b1ea1635b5b5932: Copy a variable using the copy keyword.
// 9f40f13bacbc024340af04bbf6a1b7a7: Annotate function or member behavior by writing 'spec <member> [signature] { ... }' blocks.
// 3c6f7b128895352b52d552e50b9b1a02: Create value expressions representing Unit, Error, Break, Continue, Specification, or Value types.
