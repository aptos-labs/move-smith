
//# publish
module 0xCAFE::CycleShadowUser {
    use std::vector;

    // Simple functions calling each other forming a call graph cycle

    public fun f1(x: u8): u8 {
        // Calls f2 directly, forming cycle with f2
        let y = Self::f2(x);
        y + 1
    }

    public fun f2(x: u8): u8 {
        // Calls f3 directly, forming cycle with f3
        let y = Self::f3(x);
        y + 1
    }

    public fun f3(x: u8): u8 {
        // Calls f1 directly, closing the cycle f3 -> f1 -> f2 -> f3
        if (x > 0) {
          let y = Self::f1(x - 1);
          y + 1
        } else {
          0
        }
    }

    // Import standard vector::length for shadowing test
    public fun length(v: vector<u8>): u64 {
        vector::length(&v)
    }

    // Function that shadows imported vector::length by a parameter `length`
    public fun use_shadowing(length: (vector<u8>) -> u64, v: vector<u8>): u64 {
        // Calls the parameter which shadows vector::length
        length(v)
    }

    // A function to pass as higher-order function to `use_shadowing`
    public fun custom_length(v: vector<u8>): u64 {
        // Return twice the vector length, different from vector::length
        vector::length(&v) * 2
    }

    // for function: takes a function f: (u64, u64) -> u64 and two u64 parameters
    public fun for_(f: (u64, u64) -> u64, x: u64, y: u64): u64 {
        f(x, y)
    }

    // for_user function that uses parameter shadowing of `for_` function
    public fun for_user(for_shadow: ( (u64, u64) -> u64, u64, u64) -> u64): u64 {
        // Lambda to sum two numbers
        let sum_lambda: (u64, u64) -> u64 = |a: u64, b: u64| { a + b };
        // Use for_shadow to sum first two numbers
        let partial = for_shadow(sum_lambda, 10u64, 20u64);
        // Sum third number manually
        partial + 30u64
    }

    // Runner function to execute all tests - no args needed
    public fun runner() {
        // Test call graph cycle detection and termination: call f1 with 3 (causes controlled recursion and termination)
        let _ = Self::f1(3u8);

        // Test parameter shadowing of a function named `length`
        let v = vector[1u8, 2u8, 3u8];
        // Call use_shadowing with parameter shadowing vector::length by Self::custom_length
        let _ = Self::use_shadowing(Self::custom_length, v);

        // Test for_user using for_ passed as shadowed parameter
        let result = Self::for_user(Self::for_);
        // Ignore the result; just exercise code paths
        let _ = result;
    }
}


//# run 0xCAFE::CycleShadowUser::runner


// Featurres:
// 2986aeed3df1709e402d455bbc10fc21: Identify at least one cycle in the call graph to ensure code correctness and termination.
// 0c6264ced8632d23808d99abd623d46c: Test that function parameters can correctly shadow imported module functions with the same name, including in the context of function parameters passed as lambdas.
// f77a4ce10096c533e7ee4c8587b70b5a: Test that the `for_user` function correctly computes the sum of three predefined numbers by calling the `for` function.
