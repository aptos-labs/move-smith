
//# publish
module 0xCAFE::CalcModule {
    /// A function that adds two u8 values and returns a constant if sum matches a condition
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;

        if (sum == 10) {
            42u8
        } else {
            0u8
        }
    }

    /// A function that uses a lambda to multiply by 2 and add 3, then returns the result
    public fun lambda_example(x: u8): u8 {
        let double_and_add_three: |u8| u8 has copy+drop = |val: u8| {
            (val * 2) + 3
        };
        double_and_add_three(x)
    }

    /// Inline function returning a tuple (num, num+1)
    public inline fun inline_func(x: u8): (u8, u8) {
        (x, x + 1)
    }

    /// Pattern matching demonstration with enum Color
    enum Color has copy, drop {
        Red,
        Green,
        Blue(u8)
    }

    public fun match_color(c: Color): u8 {
        match (c) {
            Color::Red => 1,
            Color::Green => 2,
            Color::Blue(intensity) => intensity,
        }
    }
}


//# run 0xCAFE::CalcModule::add_and_check --args 7u8 3u8


//# run 0xCAFE::CalcModule::add_and_check --args 1u8 2u8


//# run 0xCAFE::CalcModule::lambda_example --args 5u8


//# run 0xCAFE::CalcModule::match_color --args 0xCAFE::CalcModule::Color::Red


//# run 0xCAFE::CalcModule::match_color --args 0xCAFE::CalcModule::Color::Blue 123u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::CalcModule;

    // Function calling CalcModule's inline function and using the results
    public fun call_inline_then_add(x: u8): u8 {
        let (a, b) = CalcModule::inline_func(x);
        a + b
    }

    // Function calling CalcModule's lambda_example
    public fun call_lambda(x: u8): u8 {
        CalcModule::lambda_example(x)
    }

    // Function that matches Result from CalcModule::match_color and returns u8
    enum Status has copy, drop {
        OK,
        ERROR,
        VALUE(u8)
    }

    public fun test_match_color(c: CalcModule::Color): Status {
        let res = CalcModule::match_color(c);
        if (res == 1) {
            Status::OK
        } else if (res == 2) {
            Status::ERROR
        } else {
            Status::VALUE(res)
        }
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_then_add --args 5u8


//# run 0xCAFE::NestedCallModule::call_lambda --args 7u8


//# run 0xCAFE::NestedCallModule::test_match_color --args 0xCAFE::CalcModule::Color::Green


//# run 0xCAFE::NestedCallModule::test_match_color --args 0xCAFE::CalcModule::Color::Blue 200u8



//# run
script {
    use 0xCAFE::CalcModule;
    use 0xCAFE::NestedCallModule;

    fun main() {
        // Test add_and_check returns 42 for 7+3=10 sum case
        let res1 = CalcModule::add_and_check(7u8, 3u8);

        // Test lambda_example with 4
        let res2 = CalcModule::lambda_example(4u8);

        // Test nested call - call_inline_then_add with 6
        let res3 = NestedCallModule::call_inline_then_add(6u8);

        // Test match_color with Red
        let res4 = CalcModule::match_color(CalcModule::Color::Red);

        // Test nested match returning Status
        let res5 = NestedCallModule::test_match_color(CalcModule::Color::Blue(50u8));

        // Consume all results so that verifier passes but no assert needed
        let _ = (res1, res2, res3, res4, res5);
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 828ef181d35c3e2926bfdd916fb914b0: Ensure scripts pass the bytecode verifier before executing.
// 9ac67b0ca4a3134aeec58f90c6917a70: Use pattern matching with `Match` expressions and their arms.
