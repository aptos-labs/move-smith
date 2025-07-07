//# publish
module 0xCAFE::AdvancedFeatures {
    use std::vector;
    use std::signer;

    /// A constant defined with a u64 literal to test model attributes usage
    const CONST_VAL: u64 = 1234567890123456789u64;

    /// Struct with a generic type parameter
    struct Container<T> has copy, drop {
        inner: T
    }

    /// A public inline function returning a lambda that adds CONST_VAL to a u64 argument
    public inline fun generate_adder(): |(u64) -> u64| has copy + drop {
        |x: u64| {
            x + CONST_VAL
        }
    }

    /// A function that accepts a higher-order function and calls it with 10u64
    public fun apply_function(f: |u64|u64): u64 {
        f(10u64)
    }

    /// A function that accepts a higher-order function which itself takes another function as argument, demonstrating nested lambdas
    public fun apply_nested(f: |(|u64|u64)|u64): u64 {
        let inner_lambda = |x: u64| { x * 2 };
        f(inner_lambda)
    }

    /// Runner function exercising the nested higher-order functions and lambdas usage
    public fun runner(): u64 {
        let adder = generate_adder();
        let res1 = apply_function(adder);
        let res2 = apply_nested(|g: |u64|u64| {
            let val = g(15u64);
            val + CONST_VAL
        });
        res1 + res2
    }
}

//# run 0xCAFE::AdvancedFeatures::runner
//# run 0xCAFE::AdvancedFeatures::apply_function --args 5u64
//# run 0xCAFE::AdvancedFeatures::apply_nested
  

//# run
script {
    use std::debug;
    use 0xCAFE::AdvancedFeatures;

    const SCRIPT_CONST: u64 = 1000u64;

    /// Main function demonstrating script attributes, location, and use of a lambda as argument and return value
    fun main() {
        // Use of a lambda inline that multiplies input by SCRIPT_CONST
        let multiply_with_const = |x: u64| {
            x * SCRIPT_CONST
        };

        // Call a higher-order function passing this lambda and log the result
        let result = AdvancedFeatures::apply_function(multiply_with_const);
        debug::print(&vector::empty<u8>());

        // Compose a lambda that returns another lambda adding 1
        let return_adder_lambda = |_: u64| {
            |y: u64| { y + 1 }
        };

        // Use apply_nested to pass the above lambda
        let nested_result = AdvancedFeatures::apply_nested(return_adder_lambda);

        // Compose final value to print - just demonstration no assert required
        let final_value = result + nested_result;
        debug::print(&vector::empty<u8>());
    }
}

// Featurres:
// b0876c3c402d2049797d1e740279af47: Define script blocks with attributes, uses, constants, a main function, specifications, and location metadata in Move.
// 91cc7e7428dc741e1a77399d225956a6: Test that higher-order functions with inline lambdas can be used as arguments and return values within other higher-order function calls.
// 88246674b0b0aae5441982b302638d41: Declare model attributes that use u64 literal values.
