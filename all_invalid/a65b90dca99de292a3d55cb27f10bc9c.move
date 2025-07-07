//# publish
module 0xCAFE::LambdaShadowTest {
    use std::vector;

    // Define a struct for testing generics and type parameters
    struct Wrapper<T> has copy, drop, store, key {
        value: T
    }

    // inline function that accepts a lambda with a parameter and calls it
    public inline fun call_lambda_with_param<T, R>(x: T, f: &fun(&T): R): R {
        (*f)(&x)
    }

    // A runner function to exercise the inline lambda calls and variable scoping
    public fun runner() {
        // Declare variable with explicit type and initializer
        let a: u8 = 5u8;
        {
            // New scope with shadowing variable a (same name)
            let a: u8 = 10u8;
            // Use inline function with a lambda capturing parameter a
            let res = call_lambda_with_param<u8, u8>(a, &fun(x: &u8): u8 {
                *x + 1u8
            });
            // Variable res not asserted, just to exercise compiler & VM
            let _ = res;
        }
        // The outer `a` is still visible here, test that shadowing ended

        // Test generic struct Wrapper and instantiation with different types
        let w1 = Wrapper<u8> { value: 42u8 };
        let w2 = Wrapper<vector<u8>> { value: b"Move" };

        // Use the inline lambda call with complex argument types
        let len = call_lambda_with_param<vector<u8>, u64>(w2.value, &fun(v: &vector<u8>): u64 {
            vector::length(*v) as u64
        });

        let _ = len;
    }
}
//# run 0xCAFE::LambdaShadowTest::runner

//# publish
module 0xCAFE::vector {
    /// This shadows the std::vector module at 0x1::vector to test shadowing behavior.
    /// We re-define length function with different behavior.

    use std::vector;

    /// Shadowed length simply returns 123 to confirm this shadow is called
    public fun length<T>(_v: vector<T>): u64 {
        123
    }

    /// Also define a dummy function to test calling explicitly
    public fun dummy(): u64 {
        999
    }
}
//# run 0xCAFE::vector::dummy

//# run
script {
    use 0xCAFE::LambdaShadowTest;
    use 0xCAFE::vector;

    fun main() {
        // Call the runner function to test inline lambdas and variable shadowing
        LambdaShadowTest::runner();

        // Call the shadowed vector::length to confirm shadow is in effect
        let x = b"test";
        let len_shadowed = vector::length(x);
        let _ = len_shadowed; // Should be 123, but not asserted

        let dummy_val = vector::dummy();
        let _ = dummy_val; // 999 from shadowed module
    }
}