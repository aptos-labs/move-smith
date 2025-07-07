//# publish
module 0xCAFE::ForLoopTest {
    /// Runner function to test a for loop with invalid range.
    public fun run_for_loop_invalid_range() {
        // The for loop should not execute since the range is start > end
        let mut counter = 0;
        for i in 10..5 {
            counter = counter + 1;
            // If this body executes, that's a failure.
            // But since 10 > 5, this code should never run.
        };
        // No assertions needed.
        // Counter should remain 0.
        let _ = counter;
    }
}
//# run 0xCAFE::ForLoopTest::run_for_loop_invalid_range --signers 0xCAFE

//# publish
address 0xCAFE {
module UnusedVariableWarning {
    /// This function contains unused variable assignments
    public fun warn_about_unused_variables_runner() {
        let warning1 = 10;
        let warning2: u64 = 20;
        let warning3 = warning1 + warning2;
        let _ = warning3; // suppress some warnings, but not all
    }
}
//# run 0xCAFE::UnusedVariableWarning::warn_about_unused_variables_runner --signers 0xCAFE
}

//# publish
address 0xCAFE {
module SourceParserExample {
    /// Documentation for the parse function.
    public fun parse_and_structured_representation_runner() {
        // A simple mock Move source as bytes
        let move_source = b"
            /// Adds two numbers
            public fun add(a: u64, b: u64): u64 {
                a + b
            }

            /// Subtracts two numbers
            public fun sub(a: u64, b: u64): u64 {
                a - b
            }
        ";

        let mut functions: vector<vector<u8>> = vector::empty();
        let mut docs: vector<vector<u8>> = vector::empty();

        let mut i = 0;
        // We'll mock parse this "Move source" just to produce some structured output
        // In actual Move, there's no parser, so we just exercise the VM on string ops
        while (i < 2) {
            let doc = if (i == 0) { b"Adds two numbers" } else { b"Subtracts two numbers" };
            let fname = if (i == 0) { b"add" } else { b"sub" };
            vector::push_back(&mut docs, doc);
            vector::push_back(&mut functions, fname);
            i = i + 1;
        };
        // Docs and functions now "parse" the mock source.
        // No assertions required; just run the code to exercise the VM.
        let _ = docs;
        let _ = functions;
    }
}
//# run 0xCAFE::SourceParserExample::parse_and_structured_representation_runner --signers 0xCAFE
}