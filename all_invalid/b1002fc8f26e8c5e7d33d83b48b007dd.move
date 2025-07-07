//# publish
module 0xCAFE::ClosureShadowTest {
    use std::vector;

    /// A struct to hold location information.
    struct Location has copy, drop, store {
        start: u64,
        end_: u64,
    }

    /// A struct to represent a range binding with location.
    struct RangeBinding has copy, drop, store {
        name: u8,
        loc: Location,
    }

    /// A struct holding a range with a list of bindings and location.
    struct RangeList has copy, drop, store {
        bindings: vector<RangeBinding>,
        loc: Location,
    }

    /// Runs a passed closure that accepts a u8 and returns a u8.
    /// Demonstrates closures as parameters and invocation.
    public fun call_closure_u8<F>(value: u8, f: F): u8
        where F: Fn(u8): u8
    {
        f(value)
    }

    /// Runs a passed closure that accepts two u64 and returns a u64.
    public fun call_closure_u64<F>(a: u64, b: u64, f: F): u64
        where F: Fn(u64, u64): u64
    {
        f(a, b)
    }

    /// Demonstrates shadowing of `_` as unused variable in let binding.
    /// Returns the sum of x and y to verify correct bindings.
    public fun test_unused_variable_shadowing(x: u64, y: u64): u64 {
        let _ = 10u64;       // unused local binding
        let _ = x + y;       // unused local binding shadowing previous
        x + y
    }

    /// Demonstrates ignoring function arguments via `_`.
    public fun test_func_args_ignored(_x: u8, y: u8): u8 {
      y
    }

    /// Demonstrates pattern matching with underscores binding.
    public fun test_pattern_match_unused(n: u8): u8 {
        let (a, _, c) = (n, 42u8, 255u8);
        a + c
    }

    /// Demonstrates the use of closure that shadows `_` in its argument pattern.
    public fun test_closure_shadow_unused_arg(): u8 {
        let f = |_: u8| -> u8 { 100u8 };
        call_closure_u8(10u8, f)
    }

    /// Constructs a RangeList with some bindings and their locations.
    public fun make_range_list(): RangeList {
        let b0 = RangeBinding { name: 1u8, loc: Location { start: 0, end_: 10 } };
        let b1 = RangeBinding { name: 2u8, loc: Location { start: 11, end_: 20 } };
        let bindings = vector::empty<RangeBinding>();
        let bindings = vector::push_back(bindings, b0);
        let bindings = vector::push_back(bindings, b1);
        let loc = Location { start: 0, end_: 20 };
        RangeList { bindings, loc }
    }

    /// Runner function to invoke all tests inside the module.
    /// Returns a u64 sum of test results to avoid unused warnings.
    public fun runner(): u64 {
        // Test closures
        let sum1 = call_closure_u8(5u8, |x: u8| -> u8 { x + 1 });
        let sum2 = call_closure_u64(10u64, 20u64, |a: u64, b: u64| -> u64 { a * b });

        // Test unused variable shadowing
        let test1 = test_unused_variable_shadowing(3u64, 7u64);
        let test2 = test_func_args_ignored(100u8, 42u8);
        let test3 = test_pattern_match_unused(1u8);
        let test4 = test_closure_shadow_unused_arg();

        // Construct range list
        let rl = make_range_list();

        // Return some aggregates to confirm execution
        sum1 as u64 + sum2 + test1 + (test2 as u64) + (test3 as u64) + (test4 as u64) + rl.loc.end_
    }
}
//# run 0xCAFE::ClosureShadowTest::runner


//# run
script {
    use 0xCAFE::ClosureShadowTest;

    fun main() {
        // Run the module runner function
        let result = ClosureShadowTest::runner();
        // no assertion necessary
        // This exercises the VM with closure calls, unused variables, shadowing, and RangeList construction
    }
}

// Featurres:
// 5d96c42efcae4498b0c987a603570c37: Test that functions accepting and invoking closures as arguments work correctly, including passing and calling closures with different parameter bindings.
// 795f129e2575e5eb29c3b7b3bc46adc2: Test the handling and shadowing behavior of the unused variable `_` in local binding, function arguments, pattern matching, and lambdas in Move.
// a2088fcd0015806baed7a0033e8cd932: Construct a range list with location information for each binding and range pair.
