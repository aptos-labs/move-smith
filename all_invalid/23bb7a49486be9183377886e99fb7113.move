//# publish
module 0xCAFE::TupleModule {
    use std::string;
    use std::vector;

    // A function that takes a tuple as argument and returns multiple values
    public fun tuple_input_output(input: (u64, bool)): (u64, bool) {
        let (x, flag) = input;
        (x + 1, !flag)
    }

    // Function that returns a tuple of mixed types
    public fun multiple_return(): (u64, bool, address) {
        (42, true, @0xCAFE)
    }

    // Runner function without args for calling the above functions internally to test compiler & VM
    public fun run() {
        let input_tuple = (10u64, false);
        let (a, b) = tuple_input_output(input_tuple);
        let (c, d, e) = multiple_return();
        // Do nothing further, just simulate usage
        let _ = a;
        let _ = b;
        let _ = c;
        let _ = d;
        let _ = e;
    }
}
//# run 0xCAFE::TupleModule::run


//# publish
module 0xCAFE::TargetEnvModule {
    // This dummy module is to simulate environment setting for target code.
    // Since Move code itself does not have direct environment setting, this dummy module
    // will contain a function to just "tag" target code usage.
    public fun enable_target_mode() {
        // No op, just for testing that environment is "treating all code as target"
    }

    // Runner function for environment simulation
    public fun run() {
        enable_target_mode();
    }
}
//# run 0xCAFE::TargetEnvModule::run


//# publish
module 0xCAFE::FormatListModule {
    use std::string;
    use std::vector;

    // Formats a vector<string::String> as a comma separated string
    public fun format_list(items: vector<string::String>): string::String {
        let len = vector::length(&items);
        if (len == 0) {
            return string::utf8(b"");
        }
        let mut result = vector::borrow(&items, 0);
        let mut i = 1;
        while (i < len) {
            result = string::append(&result, &string::utf8(b", "));
            result = string::append(&result, &vector::borrow(&items, i));
            i = i + 1;
        }
        result
    }

    // Runner function to test the format_list function
    public fun run() {
        let mut items = vector::empty<string::String>();
        vector::push_back(&mut items, string::utf8(b"apple"));
        vector::push_back(&mut items, string::utf8(b"banana"));
        vector::push_back(&mut items, string::utf8(b"cherry"));
        let formatted = format_list(items);
        let _ = formatted;
    }
}
//# run 0xCAFE::FormatListModule::run


//# run 0xCAFE::TupleModule::tuple_input_output --args 7u64 true
//# run 0xCAFE::TupleModule::multiple_return

// Featurres:
// 06b69eba2cdc705b765dac83e4f8a460: Declare and use tuple and multiple return or argument types in function signatures.
// 32c9e9589dffb8fdc93267425c721b63: Set the environment to treat all code as target code if specified.
// eb777228a1668300b377b91da334f529: Format a list of displayable items as a comma-separated string.
