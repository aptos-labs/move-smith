
//# publish
module 0xCAFE::ControlFlowGenericShadow {
    use std::vector;

    // A generic struct to test generic type arguments usage
    struct Container<T> has copy, drop, store {
        value: T
    }

    // A function that takes a generic argument and returns a Container<T>
    public fun wrap_value<T>(val: T): Container<T> {
        Container<T> { value: val }
    }

    // A function testing nested control flow and shadowing of _
    public fun nested_loops_and_shadowing(): u64 {
        let acc = 0u64;
        let loop_threshold = 3u8;
        let i = 0u8;
        loop {
            if (i >= loop_threshold) {
                break;
            };
            let j = 0u8;
            while (j < loop_threshold) {
                if (j == 1) {
                    // shadow _ in let binding with pattern matching
                    let _ = j;
                    // shadow _ as variable in closure parameters
                    let closure = |_: u8| i + j;
                    acc = acc + closure(j) as u64;
                } else {
                    acc = acc + (i as u64) * (j as u64);
                };
                j = j + 1;
            };
            i = i + 1;
        };
        acc
    }

    // Function to test multiple uses of anonymous variable _
    public fun test_anonymous_var() {
        // Ignoring a value in tuple destructuring
        let (_ignored1, value1, _ignored2) = (1u8, 2u8, 3u8);

        let _ignored3 = 4u8;

        // shadowing _: _ as function arg in closure parameters
        let f = |_: u8| 42u8;
        let _res = f(7u8);

        // ignoring in pattern match arms
        let e = 1u8;
        let _match_res = match (e) {
            0 => { 0 },
            _ => { 1 },
        };

        // ignoring in a let statement
        let _ = value1;

        // re-binding _ in inner scope is allowed: shadow _ as a local variable
        let _ = 5u8;

        // nested _ in nested pattern matching
        let (a, (b, _)) = (1u8, (2u8, 3u8));
        let _ = a + b;
    }

    // Invalid usage of _ as local variable (commented out because it won't compile)
    /*
    public fun invalid_anonymous_var_usage() {
        let _ = 5u8; // cannot declare mutable _ variable
        _.0 = 10; // cannot assign to _
    }
    */
}


//# run 0xCAFE::ControlFlowGenericShadow::nested_loops_and_shadowing


//# run 0xCAFE::ControlFlowGenericShadow::wrap_value<u8> --args 42u8


//# run 0xCAFE::ControlFlowGenericShadow::test_anonymous_var


// Featurres:
// 23fb466a672110aec25bfb13409d64ed: Test that nested loop and conditional control flow statements (loop, break, loop break, if-else) execute without error in a Move script.
// 4328c9fd8c9350f162450c113234f9d6: Specify generic type arguments to a function or constructor call by following the name with '<...>' (e.g., foo<T>(args)), provided there is no whitespace after the name.
// f937f998c935ba5181a89daa92debdc1: Verify that the Move compiler correctly handles the use, scoping, shadowing, and pattern matching of the anonymous variable (_) in function arguments, local bindings, destructuring assignments, and closure parameters, including both valid and invalid usages.
