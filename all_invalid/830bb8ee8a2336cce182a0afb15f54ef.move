// This transactional test exercises named parameters and results,
// function calls with zero or more arguments separated by commas and enclosed in parentheses,
// and correct usage of `use` statement referring to bound modules.

// Address used instead of 0x1 as per instructions: 0xCAFE

//# publish
module 0xCAFE::MathUtils {
    // Public struct for demonstrating named results
    struct ResultPair has copy, drop, store, key {
        a: u64,
        b: u64,
    }

    // A function with named parameters that adds and multiplies and returns named results.
    public fun add_and_multiply(x: u64, y: u64): ResultPair {
        let sum = x + y;
        let product = x * y;
        ResultPair { a: sum, b: product }
    }

    // Function with zero arguments, returns a named result
    public fun get_magic_number(): u64 {
        42
    }

    // Runner function to call above functions without args and with args
    public fun runner(): ResultPair {
        // Calling add_and_multiply with named parameters separated by commas
        add_and_multiply(2, 3)
    }
}
//# run 0xCAFE::MathUtils::runner
//# run 0xCAFE::MathUtils::get_magic_number


// Another module that `use`s 0xCAFE::MathUtils, which must exist above and be compiled first
//# publish
module 0xCAFE::ComplexCalc {
    use 0xCAFE::MathUtils;

    struct ComplexResult has copy, drop, store, key {
        sum: u64,
        product: u64,
        magic: u64,
    }

    // Function calls MathUtils::add_and_multiply with named parameters,
    // Also calls MathUtils::get_magic_number (zero args),
    // Shows usage of all argument counts in calls.
    public fun compute(x: u64, y: u64): ComplexResult {
        let math_result = MathUtils::add_and_multiply(x, y);
        let magic = MathUtils::get_magic_number();

        ComplexResult {
            sum: math_result.a,
            product: math_result.b,
            magic: magic,
        }
    }

    public fun runner(): ComplexResult {
        compute(10, 20)
    }
}
//# run 0xCAFE::ComplexCalc::runner


//# run
script {
    use 0xCAFE::MathUtils;
    use 0xCAFE::ComplexCalc;

    fun main() {
        // Calls public function with arguments
        let r1 = MathUtils::add_and_multiply(5, 7);
        // Calls public function with zero arguments
        let r2 = MathUtils::get_magic_number();

        // Calls compute (with args) from ComplexCalc
        let cr = ComplexCalc::compute(3, 4);

        // Call runners from modules (no args)
        let run1 = MathUtils::runner();
        let run2 = ComplexCalc::runner();

        // No output or asserts needed, just usage
    }
}

// Featurres:
// 4ee2a0b08f4677e897745bd9fd7b3e2e: Use named parameters and results in functions
// 9eba3968af12eee98fb171f2f69d9992: Write function calls with zero or more arguments separated by commas and enclosed in parentheses
// 7c8accc4bf3119de7f6e9c0e17b23d0a: Ensure that the module you reference in a 'use' statement is bound and exists in the current context before compilation.
