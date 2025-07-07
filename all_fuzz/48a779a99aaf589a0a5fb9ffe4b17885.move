
//# publish
module 0xCAFE::Calculator {
    public fun add_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value after addition to test that the addition is performed
        42u8
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Calculator;

    public fun call_inline(x: u8): u8 {
        // Call inline function from Calculator module
        Calculator::inline_increment(x)
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        Calculator::with_lambda(x, y)
    }
}


//# run
script {
    use 0xCAFE::Calculator;
    use 0xCAFE::Caller;

    fun main() {
        // Test 1: add_u8_values returns 42 after addition of inputs
        let result1 = Calculator::add_u8_values(10u8, 32u8);

        // Test 2: lambda returns sum of inputs
        let result2 = Calculator::with_lambda(15u8, 25u8);

        // Test 3: calling inline function from Caller module
        let result3 = Caller::call_inline(40u8);

        // Test 2 repeated via Caller calling Calculator lambda
        let result4 = Caller::call_lambda(20u8, 22u8);

        // No assertions required, just run to exercise compiler and VM
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a7207667d1ef9745aedf7410e9b34d35: Include or exclude 'use' declarations in scripts based on custom rules.
