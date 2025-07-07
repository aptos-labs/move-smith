// #publish
module 0xCAFE::InlineClosureTest {
    /// A public inline function that accepts a closure with one u8 parameter and returns u8
    public inline fun apply_one_arg(x: u8, f: &fun(u8): u8): u8 {
        f(x)
    }

    /// A public inline function that accepts a closure with two parameters and returns their sum
    public inline fun apply_two_args(x: u8, y: u8, f: &fun(u8, u8): u8): u8 {
        f(x, y)
    }

    /// A public inline function that accepts a closure with no parameters and returns a computed u8 value
    public inline fun apply_no_arg(f: &fun(): u8): u8 {
        f()
    }

    /// Runner function to exercise the inline functions with closures
    public fun runner(): u8 {
        // Use curly braces block expression to compute a value
        let val_one: u8 = {
            let x = 5u8;
            // closure with one arg, returns arg + 3
            let closure_one = &fun(arg: u8): u8 { arg + 3u8 };
            apply_one_arg(x, closure_one)
        };

        let val_two: u8 = {
            let a = 6u8;
            let b = 4u8;
            // closure with two args, returns sum * 2
            let closure_two = &fun(arg1: u8, arg2: u8): u8 { (arg1 + arg2) * 2u8 };
            apply_two_args(a, b, closure_two)
        };

        let val_no_arg: u8 = {
            // closure with no args, returns 42
            let closure_no_arg = &fun(): u8 { 42u8 };
            apply_no_arg(closure_no_arg)
        };

        // Combine all results in a block expression and return
        {
          let unused_var = 999u8; // unused variable to test detection, but allowed
          val_one + val_two + val_no_arg  // Should be 8 + 20 + 42 = 70u8
        }
    }
}
// #run 0xCAFE::InlineClosureTest::runner

// Featurres:
// 426aee62717231b92c1e9e4a6b492596: Test that the inline function correctly accepts and executes closure arguments with different parameter configurations and returns the expected computed value.
// 6192873014e042dc5a2e54f216cd6688: Write code blocks as expressions using curly braces ('{ ... }') to denote a block expression that evaluates to the last statement's value.
// db031b0c8895602817862c5c5489c370: Ensure variables and function parameters are used (detect unused variables and parameters)
