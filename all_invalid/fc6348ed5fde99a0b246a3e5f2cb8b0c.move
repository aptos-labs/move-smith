//# publish
address 0x1 {
    module TestParsingAndLint {

        use std::vector;

        // Define a function to simulate parsing target and dependency files with address mappings
        public fun parse_targets() {
            // Dummy representation of target files parsed with address mappings
            let target_files = vector::empty<vector<u8>>();
            let dep_files = vector::empty<vector<u8>>();
            let address_map = vector::empty<address>();
            // Normally here you would parse actual files and addresses but this is a placeholder
            // to simulate compilation and VM execution

            // Just dummy operations to use variables so compiler doesn't optimize out
            std::debug::print(&vector::length(&target_files));
            std::debug::print(&vector::length(&dep_files));
            std::debug::print(&vector::length(&address_map));
        }

        // Use a struct with a #[skip(...)] attribute to test skipping lint checks
        #[skip(unknown_fields, unused_variables, dead_code)]
        struct SkippedLints {
            value: u64,
            _dummy: bool,
        }

        #[skip(invalid_boolean_expression, no_effect)]
        public fun lint_skipped_function() {
            // Here some no-effect action
            let _dummy: bool = true && false;
        }

        // Inline function foo that applies multiple lambda functions and sums their results
        public inline fun foo(x: u64): u64 {
            // lambda 1: multiply by 2
            let f1 = move |a: u64| -> u64 { a * 2 };
            // lambda 2: add 3
            let f2 = move |a: u64| -> u64 { a + 3 };
            // lambda 3: divide by 2 (integer div)
            let f3 = move |a: u64| -> u64 { a / 2 };

            f1(x) + f2(x) + f3(x)
        }

        public fun runner() {
            // Call parse_targets to simulate parsing
            parse_targets();

            // Call lint_skipped_function
            lint_skipped_function();

            // Test the inline function foo with a sample input
            let input = 10u64;
            let _result = foo(input);

            // Use _result to avoid warning
            std::debug::print(&_result);
        }
    }
}

//# run 0x1::TestParsingAndLint::runner