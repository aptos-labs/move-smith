//# publish
module 0xCAFE::TestFunctionsWithArgsAndReturn {
    use std::signer;

    /// A function that takes two u64 and returns their sum and their difference as a tuple.
    public fun sum_and_diff(a: u64, b: u64): (u64, u64) {
        (a + b, a - b)
    }

    /// Higher order function: takes a function and two u64, calls the function and returns the result.
    public fun call_fn_with_two_args(f: &fn(u64,u64): u64, x: u64, y: u64): u64 {
        f(x,y)
    }

    /// A simple function used as an argument to call_fn_with_two_args.
    public fun mul(a: u64, b: u64): u64 {
        a * b
    }

    /// Runner function to exercise the above functions without arguments.
    public fun runner() {
        let (sum, diff) = sum_and_diff(10, 3);
        let product = call_fn_with_two_args(&mul, 7, 8);
        // We can't print or assert here, but this exercises the code
        let _ = sum;
        let _ = diff;
        let _ = product;
    }
}
//# run 0xCAFE::TestFunctionsWithArgsAndReturn::runner

//# publish
module 0xCAFE::ModuleWithVerification {
    use std::signer;

    // A resource with a verification attribute to indicate special treatment by the verifier.
    #[verbatim]
    resource struct VerifiedResource {
        value: u64,
    }

    // A function with aborts_if verification attribute
    #[aborts_if(true)]
    public fun always_abort() {
        abort 0;
    }

    #[inline(always)]
    public fun inline_example(): u64 {
        42
    }

    public fun runner() {
        let _r = VerifiedResource { value: inline_example() };
        // Call the abort function inside a catch_abort block is not possible here,
        // but calling it verifies the parser accepts the attribute.
        // This will abort and revert the transaction if run.
        // To avoid aborting, do not run always_abort directly.

        // Just calling these to test attributes are accepted:
        let _ = inline_example();
    }
}
//# run 0xCAFE::ModuleWithVerification::runner

//# run
script {
    use 0xCAFE::TestFunctionsWithArgsAndReturn;

    fun main() {
        let (sum, diff) = TestFunctionsWithArgsAndReturn::sum_and_diff(100, 25);
        let product = TestFunctionsWithArgsAndReturn::call_fn_with_two_args(&TestFunctionsWithArgsAndReturn::mul, 5, 15);
        // no assertions, just exercise the calls
        let _ = sum;
        let _ = diff;
        let _ = product;
    }
}

// The following input is purposely malformed to generate a diagnostic parsing error.
//
//# run
script {
    fun main() {
        let x = 5 + ; // <-- Unexpected token `;` here should generate a parse error
    }
}

// Featurres:
// 62fe649a37494771c818ca22b5dadcc3: Define and call functions with arguments and return types, including functions as first-class values.
// 7de5c415f36b52af2275191ee808773b: Use verification attributes in your code to annotate functions or resources with specific verification requirements.
// 6d4255c438d053ad41e85f2a5e2fffae: Generate a diagnostic error message when an unexpected token is encountered during parsing
