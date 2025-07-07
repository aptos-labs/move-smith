//# publish
module 0xCAFE::SpecMembers {
    use std::signer;

    struct S has key, store {
        val: u8,
    }

    // Declare members within specification block
    spec S {
        member val: u8; // member declaration in spec block, just for test
    }

    public fun new_s(val: u8): S {
        S { val }
    }

    public fun store_s(s: signer, val: u8) {
        let obj = new_s(val);
        move_to<S>(&s, obj);
    }

    public fun check_while_loop(): bool {
        let mut count = 0;
        while (count < 6) {
            count = count + 1;
        };
        // After loop, count should be 6
        count == 6
    }

    // Test usage of types with pipe | and double pipe ||
    // For Move, since Move does not have classical union types, interpret | as function types
    // Define two functions demonstrating the pipe syntax in argument and return type positions
    public fun f_pipe(x: u8): u8 {
        x + 1
    }

    public fun g_pipe(x: bool): bool {
        !x
    }

    public fun test_pipe_lambda() {
        // Define lambda: |u8|u8 or |bool|bool, implement both separately and call
        let f: |u8| u8 = f_pipe;
        let g: |bool| bool = g_pipe;
        let _r = f(10u8);
        let _b = g(true);
    }

    public fun test_double_pipe_lambda() {
        // type that is "or" = treat as two separate lambdas, simulate using two different lambdas
        let f_or_g: (|u8| u8, |bool| bool) = (f_pipe, g_pipe);
        let (f, g) = f_or_g;
        let _ru = f(20u8);
        let _rb = g(false);
    }
}

//# run 0xCAFE::SpecMembers::check_while_loop

//# run 0xCAFE::SpecMembers::test_pipe_lambda

//# run 0xCAFE::SpecMembers::test_double_pipe_lambda

// Featurres:
// 4760b5303eec78392fef07521b1ead67: Declare members within specification blocks to define specific behaviors or properties.
// 8904a4822b34c829900e121b1fdae630: Test that a `while` loop correctly counts from 0 to 5 and that the assertion passes when the loop terminates.
// 1d9154d147857f0fb70908dd2b3e30e5: Use pipe '|' and double pipe '||' syntax to specify alternative types or type unions.
