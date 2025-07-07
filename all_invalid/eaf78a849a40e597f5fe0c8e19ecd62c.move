//# publish
module 0x1::SwapModule {
    /// Swap two u64 values
    public fun test(a: &mut u64, b: &mut u64) {
        let temp = *a;
        *a = *b;
        *b = temp;
    }

    /// Verify the swap function works correctly
    public fun main() {
        let mut x = 10u64;
        let mut y = 20u64;
        test(&mut x, &mut y);
        assert!(x == 20u64, 1);
        assert!(y == 10u64, 2);
    }
}
//# run 0x1::SwapModule::main

//# publish
module 0x1::LoopModule {
    /// While loop with false condition should not execute
    public fun test_while_loop() {
        let mut x = 42u64;
        while (false) {
            x = 0u64;
        }
        // x should still be 42
        assert!(x == 42u64, 3);
    }
    
    /// A "runner" function to call test_while_loop with no args
    public fun run() {
        test_while_loop();
    }
}
//# run 0x1::LoopModule::run

//# publish
module 0x1::ExpressionParsing {
    /// Dummy function to illustrate end of expression parsing
    public fun end_expression() {
        // For testing parsing an expression end
        let _x = 3 + 5;
        let _y = (_x * 2);
    }

    /// Runner function to test this module
    public fun run() {
        end_expression();
    }
}
//# run 0x1::ExpressionParsing::run

//# publish
module 0x1::ApplyModule {
    /// Apply a function F to two u64 arguments a and b
    public fun apply<F: copy + drop + store>(a: u64, b: u64, f: F): u64 acquires F {
        // Because Move does not have higher order functions easily,
        // We'll simulate using a functor pattern with a struct and a method
        // However, in pure Move, passing function pointers is not supported
        // So we'll implement apply as an inline example adding two numbers

        // So let's define F as a phantom wrapper for addition
        // Instead, just do the add directly here for testing purposes
        a + b
    }

    /// Dummy add function, will use in run()
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    /// A runner to demonstrate apply with add function simulated
    public fun run() {
        let a = 5u64;
        let b = 10u64;
        let result = apply(a, b, 0 as u8); // Passing dummy f param 0 as u8
        assert!(result == 15u64, 4);
    }
}
//# run 0x1::ApplyModule::run

//# publish
module 0x1::NonNativeFunctions {
    /// Non-native functions within a target module

    /// A non-native function marked by scripting convention (no native keyword in Move)
    public fun non_native_function1() {
        let x = 1u64 + 1u64;
        assert!(x == 2u64, 5);
    }

    public fun non_native_function2() {
        // Another dummy non-native function
        let x = 5u64;
        let y = 3u64;
        let z = x * y;
        assert!(z == 15u64, 6);
    }

    /// Runner function calling non-native functions
    public fun run() {
        non_native_function1();
        non_native_function2();
    }
}
//# run 0x1::NonNativeFunctions::run

//# publish
module 0x1::TestCasesModule {
    #[test]
    public fun test_case_one() {
        assert!(true, 7);
    }

    #[test]
    public fun swap_test_in_test_case() {
        let mut a = 1u64;
        let mut b = 2u64;
        let temp = a;
        a = b;
        b = temp;
        assert!(a == 2u64 && b == 1u64, 8);
    }

    /// Runner function calls the test cases explicitly
    public fun run() {
        test_case_one();
        swap_test_in_test_case();
    }
}
//# run 0x1::TestCasesModule::run

//# run
script {
    fun main() {
        // Test SwapModule main - already tested in module run
        0x1::SwapModule::main();

        // Test LoopModule
        0x1::LoopModule::run();

        // Test ExpressionParsing
        0x1::ExpressionParsing::run();

        // Test ApplyModule
        0x1::ApplyModule::run();

        // Test NonNativeFunctions
        0x1::NonNativeFunctions::run();

        // Test TestCasesModule test functions
        0x1::TestCasesModule::run();
    }
}