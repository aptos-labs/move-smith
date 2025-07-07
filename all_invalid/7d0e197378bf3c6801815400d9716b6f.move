
//# publish
module 0xCAFE::DecreasingVariables {
    // This module demonstrates variable bindings with unpacking,
    // module attributes (with a simulated deprecation notice comment),
    // and functions with 'decreases' expressions for termination.

    // Simulated deprecation warning as a comment (Move currently does not support attributes)
    // @deprecated(reason = "Use a better module instead")
    const DEPRECATED_CONST: u64 = 42;

    struct Pair has copy, drop, store {
        a: u64,
        b: u64,
    }

    /// Function demonstrating variable bindings with unpacking using braces and parentheses.
    public fun var_unpacking_examples() {
        let p = Pair { a: 5, b: 10 };

        // Unpack with braces
        let Pair { a: a1, b: b1 } = p;

        // Unpack with parentheses tuple syntax - for tuples only
        let (x, y) = (a1, b1);

        // Nested unpacking example
        let (Pair { a: a2, b: b2 }, z) = (p, 100u64);

        let _ = (x, y, a2, b2, z);
    }

    /// Recursive function using 'decreases' to ensure termination.
    /// Computes the sum 1 + 2 + ... + n
    public fun sum_n(n: u64): u64 acquires Pair {
        // Termination metric: n decreases on each call
        if (n == 0) {
            0
        } else {
            let rest = sum_n(n - 1);
            n + rest
        }
    }

    /// Function using a while loop with decreases.
    public fun countdown(mut count: u8) {
        // 'while' loops implicitly require decreases expression for termination,
        // but in Move, decreases must be explicit in recursion.
        while (count > 0) {
            count = count - 1;
        };
    }
}


//# run 0xCAFE::DecreasingVariables::var_unpacking_examples


//# run 0xCAFE::DecreasingVariables::sum_n --args 10u64


//# run 0xCAFE::DecreasingVariables::countdown --args 5u8


// Featurres:
// 85a5c83a3365a06e8dbdf2e8eb2304a5: Declare variable bindings with optional unpacking syntax using braces or parentheses
// 077676b81672e365f5aab6144eb108f0: Set module attributes and handle deprecation warnings.
// a3cc1c7e5a447e22cf5d1b108bcb21e5: Declare 'decreases' expressions for termination metrics.
