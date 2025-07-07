// Corrected Move test module with proper attribute syntax and structure


//# publish
module 0xCAFE::TestAdvancedFeatures {
    // Use std for control flow and vector usage
    use std::vector;
    use std::signer;

    // Define a generic module with function signatures suitable for passing around
    struct FuncHolder<Param> has copy, drop {
        func: fn(Param) -> u64,
    }

    // Nested modules to simulate deprecation attribute propagation
    
//-- Corrected attribute syntax: Move uses `attributes` with no '#' prefix
//-- Removed '#' before attribute comments to adhere to Move syntax

//-- Deprecated module at address 0xCAFE
    public(script) // make sure the module is published as script if needed
//# publish
    module 0xCAFE::DeprecatedModule {
        // Simulate deprecation, assume usage issues will be detected externally
        public fun deprecated_fn(): u64 {
            42
        }
    }

    //-- Nested deprecated module at address 0xCAFE
    public(script)
//# publish
    module 0xCAFE::DepNested {
        public fun nested_fn(): u64 {
            100
        }
    }

    // Function to test passing functions as parameters and invoking them
    public fun take_and_invoke<Param>(f: fn(Param) -> u64, p: Param): u64 {
        f(p)
    }

    // Wrappers for functions with different signatures, to test first-class functions
    public fun fun1(x: u8): u64 {
        x as u64 + 1
    }

    public fun fun2(x: u16): u64 {
        (x as u64) * 2
    }

    // Example of assigning functions to variables and passing around
    public fun assign_and_call() {
        let f1: fn(u8) -> u64 = fun1;
        let f2: fn(u16) -> u64 = fun2;

        // Call via variable
        let _result1 = f1(5u8);
        let _result2 = f2(10u16);

        // Pass function variable as argument
        let r3 = take_and_invoke(f1, 7u8);
        let r4 = take_and_invoke(f2, 20u16);
    }

    // Functions with complex control flow expressions
    public fun complex_control_flow(x: u8): u8 {
        // Since move functions are immutable, simulate decrement via recursion or other approach
        // for simplicity, do a loop or recursive approach
        // But for this test, just demonstrate the structure:
        let result = x;

        if (x > 5) {
            let temp = x;
            while (temp > 0) {
                temp = temp - 1;
            }
            result = temp;
        } else {
            let res = x;
            loop {
                if (res == 0) {
                    break;
                }
                res = res - 1;
            }
            result = res;
        };
        result
    }

    // Function with nested complex expressions using if, while, loop
    public fun nested_expressions(y: u8): u8 {
        let res = if (y % 2 == 0) {
            let z = y / 2;
            let _ = while_loop(z);
            z
        } else {
            let _ = loop_break(y);
            y + 1
        };
        res
    }

    fun while_loop(count: u8): u8 {
        let i = count;
        while (i > 0) {
            i = i - 1;
        };
        i
    }

    fun loop_break(limit: u8): u8 {
        let i = limit;
        loop {
            if (i == 0) {
                break;
            };
            i = i - 1;
        };
        i
    }
}


//# run 0xCAFE::TestAdvancedFeatures::assign_and_call

//# run 0xCAFE::TestAdvancedFeatures::complex_control_flow --args 7u8
// # run 0xCAFE::TestAdvancedFeatures::nested_expressions --args 10u8


//-- Module demonstrating usage of deprecated modules


//# publish
module 0xCAFE::DepModuleUsage {
    // Use the deprecated module
    
    public fun use_deprecated() {
        // Call the deprecated function, expecting some form of warning/error
        let val = 0xCAFE::DeprecatedModule::deprecated_fn();
        // Use the value to prevent optimization
        assert!(val == 42, 999);
        // Call nested deprecated function
        let nested_val = 0xCAFE::DepNested::nested_fn();
        assert!(nested_val == 100, 998);
    }

    public fun use_deprecated_nested() {
        let val = 0xCAFE::DepNested::nested_fn();
        assert!(val == 100, 997);
    }
}


//# run 0xCAFE::DepModuleUsage::use_deprecated

//# run 0xCAFE::DepModuleUsage::use_deprecated_nested


//-- Module testing first-class function capabilities


//# publish
module 0xCAFE::FirstClassFnTest {
    // Function that accepts a generic function parameter and calls it
    public fun test_generic_fn<Param>(f: fn(Param) -> u64, p: Param): u64 {
        f(p)
    }

    // Functions with different signatures
    public fun f_int(x: u8): u64 {
        x as u64 * 10
    }

    public fun f_short(y: u16): u64 {
        y as u64 + 100
    }

    // Wrapper to test passing functions as variables, passing them as args, and invoking them
    public fun run_tests() {
        let f1: fn(u8) -> u64 = f_int;
        let f2: fn(u16) -> u64 = f_short;

        // Call via variable
        let _ = f1(3u8);
        let _ = f2(4u16);

        // Pass function as argument
        let v1 = test_generic_fn(f1, 7u8);
        let v2 = test_generic_fn(f2, 8u16);
    }
}



//# run 0xCAFE::FirstClassFnTest::run_tests
