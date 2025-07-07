//# publish
module 0x1::UninitUseCheckerTest {
    use std::signer;

    /// A function that intentionally uses an uninitialized local variable.
    /// This is to check UninitializedUseChecker detection during compilation.
    public fun cause_uninitialized_use() {
        // Declare a local variable without initialization
        let x: u64;
        // Use 'x' without initialization
        let _y = x;
    }

    /// Runner function that calls the function expected to cause uninitialized use.
    public fun runner() {
        // This call is expected to trigger the uninitialized variable use detection.
        cause_uninitialized_use();
    }
}
//# run 0x1::UninitUseCheckerTest::runner


//# publish
module 0x1::StringLiteralEscapeTest {
    /// Function to test closing quote position detection in string literals with escapes.
    public fun check_closing_quote() {
        // A string literal with escape sequences
        let s = "Line1\\nLine2\\\"Here\\\"End";
        // Dummy usage of s to avoid unused variable warning
        let _len = std::string::utf8_length(&s);
    }

    public fun runner() {
        check_closing_quote();
    }
}
//# run 0x1::StringLiteralEscapeTest::runner


//# publish
module 0x1::SkipLintTest {
    #[skip(unused_variable, uninitialized_variables)]
    /// This function skips the lint checks for unused variables and uninitialized use.
    public fun skip_lint_checks() {
        let x: u64;
        // Not initializing and not using x; normally triggers lint errors.
    }

    /// Normal function to show no skip attribute here.
    public fun normal_function() {
        let y: u64;
        let _ = y; // This should trigger uninitialized use
    }

    public fun runner() {
        skip_lint_checks();
        // Not calling normal_function to avoid abort from uninitialized use.
    }
}
//# run 0x1::SkipLintTest::runner


//# run
script {
    use 0x1::UninitUseCheckerTest;
    use 0x1::StringLiteralEscapeTest;
    use 0x1::SkipLintTest;

    fun main(account: signer) {
        // Run the runners explicitly too
        UninitUseCheckerTest::runner();
        StringLiteralEscapeTest::runner();
        SkipLintTest::runner();
    }
}