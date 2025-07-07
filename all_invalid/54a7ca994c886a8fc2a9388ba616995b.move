//# publish
module 0xCAFE::SpecPatterns {
    // This module tests specification patterns with identifier fragments and asterisks,
    // including adjacent fragments and wildcards without spaces.

    use std::signer;
    use std::vector;

    /// A dummy struct to help cover patterns with fields.
    struct Data has copy, drop, store {
        x: u64,
        y: bool,
    }

    /// Function to be called without arguments as runner.
    public fun runner() {
        // Spec block with complex patterns and name patterns
        // Testing identifier fragments combined with asterisks without spaces.

        spec {
            // Pattern matching on variable names for spec patterns:
            // Using _ as part of pattern and wildcard *
            #[verifier(pattern_name = "x*")]
            let xstar = 5u64;

            #[verifier(pattern_name = "a_b*")]
            let abstar = 10u64;

            #[verifier(pattern_name = "*_star")]
            let wild_star = true;

            #[verifier(pattern_name = "no*space*pattern")]
            let nospaces = 42u64;

            // Nested pattern with wildcard and named fragments
            #[verifier(spec_name = "frag*frag*")]
            let twofrags = 1u8;

            // Using a pattern with only *
            #[verifier(pattern_name = "*")]
            let onlystar = 0u8;

            // Complex struct destructuring pattern name
            #[verifier(pattern_name = "Data_f*ld")]
            let data_field = Data { x: 1, y: true };

            // Combining all above in a tuple pattern
            #[verifier(pattern_name = "tuple*pattern*test")]
            let (a, b, c) = (xstar, abstar, nospaces);
        }
    }

    /// Function to test creating a built-in function call (intrinsic call) with location, name, types and expressions
    public fun builtin_call_test(): u64 {
        // Simulating a builtin call creation using dummy params
        let loc = 1u8; // dummy location
        // Note: This is only an emulation as direct builtin call creation isn't exposed in Move,
        // but we prepare args and call an intrinsic Move std function which is builtin.
        // We'll test calling `vector::length` builtin which is intrinsic.

        let v = vector::empty<u8>();
        let length = vector::length(&v);
        length
    }
}

//# run 0xCAFE::SpecPatterns::runner
//# run 0xCAFE::SpecPatterns::builtin_call_test

//# publish
module 0xCAFE::AnonVar {
    // This module tests the anonymous variable (_) usages in various contexts,
    // including function arguments, local bindings, destructuring assignments,
    // and closure parameters. Also some invalid usages commented for clarity.

    use std::signer;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    public fun no_args(_ignored: u64) {
        // Valid use: _ as function argument, variable unnamed and ignored
        // No use of _ inside
    }

    public fun multiple_args(a: u64, _b: bool, _c: u8) {
        // Valid: Anon vars as some params ignored.
        let x = a + 1;
    }

    public fun shadow_anon() {
        // _ can occur in let patterns - variable not bound.
        let _ = 5u8; // discarding value

        // Destructuring with ignoring
        let (x, _ , y) = (1u64, 2u64, 3u64);
        let p = Point { x: x, y: y };
    }

    public fun nested_underscore() {
        let point = Point { x: 10, y: 20 };
        // pattern matching with _ in struct
        let Point { x: a, y: _ } = point;

        // allowed use in nested pattern
        let (a, _) = (1u8, 2u8);
    }

    public fun closure_underscore() {
        // Closure with argument _ (allowed)
        let f = |_: u64| { 42u64 };
        let _res = f(100);
    }

    // The following are invalid usages and won't compile or are disallowed:
    // Commented out to avoid compilation errors.
    /*
    public fun invalid_anon_return() {
        let _ = 5;
        return _; // Error: cannot use _ as expression
    }

    public fun invalid_anon_assign() {
         _ = 10; // Error: cannot assign to _
    }

    public fun invalid_anon_destruct() {
        let (a, _, _) = (1,2,3);
        let (_, _) = (1,2); // error: underscore cannot be tuple variable
    }
    */

    public fun runner() {
        no_args(123);
        multiple_args(1, true, 255);
        shadow_anon();
        nested_underscore();
        closure_underscore();
    }

}

//# run 0xCAFE::AnonVar::runner

// Featurres:
// beed001108a54ff28941535d37c42e3d: Create specification patterns with a name pattern composed of identifier fragments and asterisks, allowing adjacent identifier fragments or wildcards without spaces.
// f937f998c935ba5181a89daa92debdc1: Verify that the Move compiler correctly handles the use, scoping, shadowing, and pattern matching of the anonymous variable (_) in function arguments, local bindings, destructuring assignments, and closure parameters, including both valid and invalid usages.
// 5a520cf07a0f696135381fdd5e8fd426: Create a built-in function call with a specified location, name, optional type arguments, and list of expressions as arguments.
