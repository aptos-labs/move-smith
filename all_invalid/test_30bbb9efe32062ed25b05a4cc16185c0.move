//# publish
module 0xA10B::EarlyReturnTest {
    public fun terminate_early(flag: bool): bool {
        if (flag) {
            return true; // Early exit
        }
        false
    }

    public fun test_early_return() {
        let result_true = terminate_early(true);
        let result_false = terminate_early(false);
        // The assertion after the early return should not execute if early return works.
        // But as per Move semantics, assertions can be placed elsewhere.
        assert!(result_true == true, 100);
        assert!(result_false == false, 101);
    }

    public fun main() {
        test_early_return();
    }
}

//# run 0xA10B::EarlyReturnTest::main

//# publish
module 0xA10B::InlineFunctionInteraction {
    // Inline function that calls a passed function and adds its result to a fixed value
    inline fun call_with_args(f: |u64, u64| u64, g: |u64, u64| u64, a: u64, b: u64): u64 {
        let res_f = f(a, b);
        let res_g = g(a, b);
        res_f + res_g
    }

    fun double_sum(x: u64, y: u64): u64 {
        x + y
    }

    fun triple_sum(x: u64, y: u64): u64 {
        x * y / if y != 0 { y } else { 1 }
    }

    public fun test_inline_calls() {
        assert!(call_with_args(double_sum, triple_sum, 4, 5) == (4 + 5) + (4 * 5 / 5), 200);
    }
}
//# run 0xA10B::InlineFunctionInteraction::test_inline_calls

//# publish
module 0xA10B::LoopAndAssignment {
    // Testing variable updates and loops with loop control
    public fun compute_factorial(n: u64): u64 {
        let result = 1;
        let counter = 1;
        while (counter <= n) {
            result = result * counter;
            counter = counter + 1;
        };
        result
    }

    public fun verify_loop_behavior() {
        let fact_5 = compute_factorial(5);
        assert!(fact_5 == 120, 300);
    }
}
//# run 0xA10B::LoopAndAssignment::verify_loop_behavior