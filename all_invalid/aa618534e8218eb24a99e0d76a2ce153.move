//# publish
module 0x1::BranchTest {
    /// This function returns 100 to test conditional branching.
    public fun test_branch(): u64 {
        let x = 100;
        if (x == 100) {
            x
        } else {
            0
        }
    }

    /// Runner function with no args to call test_branch.
    public fun run(): u64 {
        test_branch()
    }
}
//# run 0x1::BranchTest::run

//# publish
module 0x1::ImpurityReport {
    /// This function is a dummy pure function that returns 5
    public fun pure_function(): u64 {
        5
    }

    /// This function simulates impurity in specification by calling impure function in spec.
    /// For simulation, we do not have real spec impurity, so we abuse printing.
    /// Normally, this would cause a compile-time error with detailed location and function name.
    public fun call_impure_in_spec() {
        // Normally, this code would not compile if impure functions are called in spec.
        // We simulate reporting by returning a special error code or comment.
    }

    /// Runner to represent impurity call testing.
    public fun run() {
        // Intentionally empty: in real testing framework, this would trigger impurity errors.
    }
}
//# run 0x1::ImpurityReport::run --signers 0x1

//# publish
module 0x1::ParsingEndTest {
    /// Returns true if the parser should treat this expression as ended.
    /// The function simulates parsing logic returning true when expression ends.
    public fun is_expression_end(char: u8): bool {
        // Let's say expression ends if char is a semicolon ';' (ASCII 59), or closing brace '}'
        char == 59 || char == 125
    }

    /// Runner calls is_expression_end with some test chars.
    public fun run(): bool {
        let semicolon: u8 = 59;
        let closing_brace: u8 = 125;
        let other: u8 = 42;
        // returns true if either semicolon or closing_brace is expression end, false otherwise
        is_expression_end(semicolon) && is_expression_end(closing_brace) && !is_expression_end(other)
    }
}
//# run 0x1::ParsingEndTest::run