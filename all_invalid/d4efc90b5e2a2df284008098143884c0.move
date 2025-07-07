//# publish
module 0x1::test_module {
    use std::option;

    /// Function to test if-else variable assignment and returning the value
    public(entry) fun assign_value_in_if_else(cond: bool): u8 {
        let result: u8;
        if (cond) {
            result = 42;
        } else {
            result = 7;
        };
        result
    }

    /// Function with optional type annotations for variables (demonstrates optional types)
    public(entry) fun optional_type_demo(opt: option::Option<u64>): u64 {
        let value: u64;
        if (option::is_some(&opt)) {
            value = *option::extract(&opt);
        } else {
            value = 0;
        };
        value
    }

    /// Helper function to check specifications (ensuring no panics, correct logic)
    public(pure) fun check_specifications() {
        // Example specification check: ensure assign_value_in_if_else returns expected values
        let res_true = assign_value_in_if_else(true);
        assert!(res_true == 42, 100);
        let res_false = assign_value_in_if_else(false);
        assert!(res_false == 7, 101);

        // Check optional handling
        let some_value = option::some(123u64);
        let val1 = optional_type_demo(&some_value);
        assert!(val1 == 123, 102);
        let none_value = option::none<u64>();
        let val2 = optional_type_demo(&none_value);
        assert!(val2 == 0, 103);
    }
}

//# run 0x1::test_module::check_specifications