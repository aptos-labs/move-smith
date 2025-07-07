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

    /// Runs a passed function that accepts a u8 and returns a u8.
    /// Since Move does not support closures as first-class citizens,
    /// using a generic function pointer style parameter is not allowed.
    /// Instead, simulate by passing function references with the same signature.
    /// So we remove the `where F: Fn(...)` constraint and rewrite as a normal function call.
    public fun call_closure_u8(value: u8, f: &fn(u8): u8): u8 {
        (*f)(value)
    }

    /// Similarly for two u64 args.
    public fun call_closure_u64(a: u64, b: u64, f: &fn(u64, u64): u64): u64 {
        (*f)(a, b)
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

    /// Since Move doesn't support closures or lambdas in the way Rust does,
    /// simulate by defining an explicit function.
    public fun closure_shadow_unused_arg(_x: u8): u8 {
        100u8
    }

    /// Simulate calling above closure by passing function reference.
    public fun test_closure_shadow_unused_arg(): u8 {
        call_closure_u8(10u8, &closure_shadow_unused_arg)
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
        // Inline functions cannot be nested; move them here as declared functions

        // Define explicit functions to pass as arguments
        // Moved outside runner so must be declared here as separate public functions
        0
    }
    /// Helper function add_one used by runner
    public fun add_one(x: u8): u8 {
        x + 1
    }

    /// Helper function mul used by runner
    public fun mul(a: u64, b: u64): u64 {
        a * b
    }

    /// Proper runner function implementation calling helpers above
    public fun runner(): u64 {
        // Test closures via function references
        let sum1 = call_closure_u8(5u8, &add_one);
        let sum2 = call_closure_u64(10u64, 20u64, &mul);

        // Test unused variable shadowing
        let test1 = test_unused_variable_shadowing(3u64, 7u64);
        let test2 = test_func_args_ignored(100u8, 42u8);
        let test3 = test_pattern_match_unused(1u8);
        let test4 = test_closure_shadow_unused_arg();

        // Construct range list
        let rl = make_range_list();

        // Return some aggregates to confirm execution
        (sum1 as u64) + sum2 + test1 + (test2 as u64) + (test3 as u64) + (test4 as u64) + rl.loc.end_
    }
}
//# run 0xCAFE::ClosureShadowTest::runner


//# run
script {
    use 0xCAFE::ClosureShadowTest;

    fun main() {
        // Run the module runner function
        let _result = ClosureShadowTest::runner();
        // no assertion necessary
        // This exercises the VM with function calls simulating closure calls,
        // unused variables, shadowing, and RangeList construction
    }
}