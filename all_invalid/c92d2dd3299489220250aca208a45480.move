
//# publish
module 0xCAFE::AnnotationFormatterTest {
    use std::vector;

    // A global variable to hold the registered formatter, for simulation purposes.
    // In real code, this would involve some runtime registry or callback.
    struct FormatterRegistry has store, key {
        formatter: option<function() -> ()>,
    }

    // Initialize the registry
    public fun initialize_registry() {
        let reg = FormatterRegistry {formatter: option::none()};
        move_to<FormatterRegistry>(&signer::address_of(&signer::address_of_global()), reg);
    }

    // Register a custom formatter (simulate by storing a dummy function)
    public fun register_formatter() {
        // For testing, we just store some dummy function reference.
        let dummy_fun: function() -> () = dummy_formatter;
        let reg_ref: &mut FormatterRegistry = borrow_global_mut<FormatterRegistry>(0xCAFE);
        reg_ref.formatter = option::some(dummy_fun);
    }

    // Dummy formatter function body
    fun dummy_formatter() {
        // Do nothing
    }

    // Use the formatter: For testing, invoke the stored function
    public fun invoke_formatter() {
        let reg_ref: &mut FormatterRegistry = borrow_global_mut<FormatterRegistry>(0xCAFE);
        match &reg_ref.formatter {
            option::some(f) => f(), // invoke dummy formatter
            option::none() => (),
        };
    }

    // Use wildcard '*' in spec (simulate with a special value, e.g., 0xFFFFFFFF)
    public fun spec_with_wildcard() {
        // Suppose '*' is represented by u8::max_value()
        let wildcard: u8 = u8::max_value();
        let specific_value: u8 = 42;

        // Specification pattern
        if (specific_value == * /* wildcard in spec */) {
            // This block is for the wildcard
            // (won't run since 42 != 255)
        } else {
            // Match specific value
            let _ = specific_value;
        }

        // Simulate pattern matching with wildcard
        let input_value: u8 = 255; // will match '*'
        if (input_value == u8::max_value()) {
            // Handle wildcard case
        } else {
            // Handle specific case
        }
    }

    // Nested spec block for detailed specifications
    public fun nested_specification() {
        // Outer spec block
        // For illustration: Testing nested function within spec

        // Innermost specification
        fun inner_spec(x: u64): u64 {
            if (x > 100) {
                x + 10
            } else {
                x - 10
            }
        }

        // Call the inner spec with different values
        let result1 = inner_spec(150);
        let result2 = inner_spec(50);

        // No assertions needed; this is a test setup
        result1
        result2
    }
}


//# run 0xCAFE::AnnotationFormatterTest::initialize_registry --signers 0xCAFE

//# run 0xCAFE::AnnotationFormatterTest::register_formatter

//# run 0xCAFE::AnnotationFormatterTest::invoke_formatter

//# run 0xCAFE::AnnotationFormatterTest::spec_with_wildcard

//# run 0xCAFE::AnnotationFormatterTest::nested_specification

// Featurres:
// a3964e504b08f3d99b40f8ea51d3fd1f: Register custom annotation formatters for debugging and testing purposes
// ceee5fe0e6121c6a5a0828738bcf4535: Use a wildcard `*` in specifications to represent any value.
// 0b3188b910069a5f4cc923ef2dc33263: Include nested function bodies within spec blocks for detailed specifications.
