//# publish
module 0xCAFE::TestVerifyOnly {
    // 1. #[verify_only] attribute usage
    #[verify_only]
    public fun verify_purpose_only_fun(x: u64): u64 {
        // Function that's only intended for verification
        x + 123
    }

    // A normal function to be "passed as an argument"
    public fun adder(y: u64): u64 { y + 1 }

    // Provide a runner that demonstrates "passing" by direct call
    public fun example_fun_param_runs(): u64 {
        // Use adder directly since Move doesn't allow passing functions as values
        Self::adder(41)
    }

    // 3. while loop with variable mutation & value preservation
    public fun looping_sum(n: u64): u64 {
        let i = 0;
        let sum = 0;
        while (i < n) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    public fun loop_runner(): u64 { looping_sum(5) }

    // For direct testing purpose
    public fun runner(): (u64, u64) {
        (example_fun_param_runs(), loop_runner())
    }
}

//# run 0xCAFE::TestVerifyOnly::runner --signers 0xCAFE

//# run 0xCAFE::TestVerifyOnly::loop_runner --signers 0xCAFE

//# publish
module 0xCAFE::TestWhileLoop {
    // Simple function that demonstrates while loop mutation and state persistence
    public fun double_until(limit: u64): u64 {
        let x = 1;
        while (x < limit) {
            x = x * 2;
        };
        x
    }

    public fun run_double_until_10(): u64 { double_until(10) }
}

//# run 0xCAFE::TestWhileLoop::run_double_until_10 --signers 0xCAFE

//# run
script {
    use 0xCAFE::TestWhileLoop;

    fun main() {
        // Suppress warnings about unused variables by prefixing with _
        let _result = TestWhileLoop::double_until(20);
        let _result2 = TestWhileLoop::double_until(100);
    }
}

//# publish
module 0xCAFE::FuncReturnFuncTest {
    // Simulating the effect: function that takes an input function by name, and returns a struct
    struct ReturnedFun has copy, drop {
        value: u64,
    }

    public fun plus_ten(x: u64): u64 { x + 10 }

    public fun input_function(arg: u64): ReturnedFun {
        // Use plus_ten as the input "function"
        let v = Self::plus_ten(arg);
        ReturnedFun { value: v }
    }

    // Provide a runner for this demo
    public fun test_function_returns_funstruct(): u64 {
        let ret = input_function(7);
        ret.value
    }
}

//# run 0xCAFE::FuncReturnFuncTest::test_function_returns_funstruct --signers 0xCAFE

// Features:
// c62bb3e584566505b6ce583c407ff80c: Annotate Move functions, modules, or items with the #[verify_only] attribute to indicate that they should be used only for verification purposes and not included in normal execution.
// 960f290e3dbdbd5e860ccd976e950750: Identify function parameters whose return type contains a function
// 9c37e4b9222ad023f1ab960bec77f25f: Test that the Move functions correctly handle while loops with variable updates and preserve variable values through multiple iterations.
