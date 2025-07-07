
//# publish
module 0xCAFE::SpecLocalLoopTest {
    use std::signer;

    struct Data has copy, drop, store {
        a: u64,
        b: u64,
    }

    /// Standalone spec function to express sum invariant
    spec fun sum_spec(d: Data): u64 {
        d.a + d.b
    }

    /// Function returning multiple values, stored to locals and stack
    public fun multiple_return(x: u64): (u64, u64) {
        let a = x + 1;
        let b = x + 2;
        (a, b)
    }

    /// Function with a while loop that breaks immediately,
    /// Ensures the body runs exactly once, mutates locals.
    public fun single_loop(mut_val: u64): u64 {
        let counter = 0u64;
        let val = mut_val;
        while (true) {
            val = val + 42;
            counter = counter + 1;
            break;
        };
        // After the loop, val and counter are updated once
        val + counter
    }

    /// Runner function combining multiple_return and single_loop,
    /// stores return values into locals and stack and returns final u64.
    public fun runner(x: u64): u64 {
        let (v1, v2) = multiple_return(x);
        let acc = v1 + v2;

        let after_loop = single_loop(acc);
        after_loop
    }

    /// Spec block capturing state before and after runner call,
    /// asserting locals and stack values meet expected criteria.
    spec module {
        spec fun runner(x: u64) {
            let old_x = old(x);
            let (a, b) = multiple_return(old_x);
            let before_sum = a + b;
            let after = single_loop(before_sum);

            // Assert locals match spec expectations
            assert!(a == old_x + 1, 1001);
            assert!(b == old_x + 2, 1002);
            assert!(after == before_sum + 42 + 1, 1003);
        }
    }
}



//# run 0xCAFE::SpecLocalLoopTest::multiple_return --args 10u64



//# run 0xCAFE::SpecLocalLoopTest::single_loop --args 100u64



//# run 0xCAFE::SpecLocalLoopTest::runner --args 10u64


// Features:
// 2d43e4a10d589db638bb9f85e95848c5: Define standalone specification functions and spec blocks for your Move code.
// 2a06a5c3c4311fb5835a792534913bac: Test that values returned from a function are properly saved to locals and managed on the stack when they must be used multiple times in subsequent operations.
// 6ae1a4a92c515bf00dd9597df1ee03bf: Verify that a while loop with an immediate break correctly executes and updates the variable as expected.
