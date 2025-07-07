
//# publish
module 0xCAFE::CaptureShadowing {
    use AptosStd::Debug;

    // Change &fun(...) to &Fn(...) since Move uses Fn traits for function references
    public fun foo(x: u8, f: &Fn(u8): u8): u8 {
        // Apply the function to x
        Fn::call(f, x)
    }

    public fun test_shadowing_and_capture(): u8 {
        let x = 1u8;
        // Define a function that shadows and increments x
        let incrementer = fun(x: u8): u8 {
            let x = x + 1; // shadowing outer x with param x incremented
            x + 1 // returns the value incremented twice total
        };
        let result = foo(x, &incrementer);
        // result should be 3 ( (1+1)+1 )
        result
    }

    public fun test_call_with_multiple_args() {
        let a = 10u8;
        let b = 20u8;
        let c = 30u8;
        let sum = add_three(a, b, c);
        Debug::print(&sum);
    }

    public fun add_three(a: u8, b: u8, c: u8): u8 {
        a + b + c
    }

    struct PropertySet has copy, drop {
        prop1: bool,
        prop2: u8,
        prop3: u16,
    }

    public fun test_property_set(): PropertySet {
        let p = PropertySet {
            prop1: true,
            prop2: 42u8,
            prop3: 1000u16,
        };
        p
    }

    public fun get_env_vars(): (vector<u8>, vector<u8>) {
        let mvc_exp = Debug::get_env(b"MVC_EXP");
        let move_compiler_exp = Debug::get_env(b"MOVE_COMPILER_EXP");
        (mvc_exp, move_compiler_exp)
    }
}




//# run 0xCAFE::CaptureShadowing::test_shadowing_and_capture




//# run 0xCAFE::CaptureShadowing::test_call_with_multiple_args




//# run 0xCAFE::CaptureShadowing::test_property_set




//# run 0xCAFE::CaptureShadowing::get_env_vars
