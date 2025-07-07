
//# publish
module 0xCAFE::TestAnonymousVar {
    use std::signer;
    use 0xCAFE::MyModule;

    // Function demonstrating correct use of shadowing and anonymous variables in parameters and local bindings
    public fun test_shadowing_and_anonymous_vars(flag: bool, _discard: u8, value: u64): u64 {
        // shadowing parameter `flag` with local variable
        let flag = if (flag) {
            true
        } else {
            false
        };

        // using anonymous variable in let binding, shadowed by existing variable
        let _ = if (flag) { 1 } else { 0 };
        // using anonymous variable in destructuring assignment
        let (a, _) = MyModule::f2(5);
        // destructure tuple returned by inline function
        let (b, c) = MyModule::f2(10);

        // Passing a call to a named address + function call with argument
        let addr = 0x1b2e3f4a5f6b7d8c; // a different address
        let result = (addr()(42u8));

        // Re-using anonymous variable in nested scope
        let sum = {
            let _ = b + c;
            b + c + value as u16
        };

        // Shadowing variable `a` with a new binding
        let a = a as u32;
        // No illegal use of anonymous variable after shadowing

        // Return combined value for test
        a as u64 + sum as u64 + result as u64
    }

    // Valid use: pattern matching with destructuring, including anonymous variable pattern
    public fun match_struct(s: MyModule::S): u32 {
        match (s) {
            // match with explicit binding
            MyModule::S { x, y } => x + y,
            // match with ignore variable
            _ => 0,
        }
    }

    // Invalid pattern: duplicate anonymous variable (_) in same pattern. should error if uncommented
    // public fun invalid_pattern(s: MyModule::E) {
    //     match (s) {
    //         MyModule::E::V2(_, _, _) => { } // error if multiple _ in same pattern
    //     }
    // }

    // Closure with parameters, including anonymous and named
    public fun closure_test() {
        // valid closure with anonymous parameter
        let _ = |_: u8| { 42 };

        // valid closure with named parameter
        let f = |a: u8| { a + 1 };
        let _ = f(2);
    }

    // Invocation of module function with address as function call
    public fun call_with_address() {
        let addr = 0x1b2e3f4a5f6b7d8c;
        // call address + function
        let _res = (addr()(123u8));
    }

    // Function testing type analysis on struct fields
    public fun type_field_analysis(s: MyModule::S): (u32, u32) {
        // get x field and check base type (u32)
        let x_type = s.x;
        // get y field and check base type (u32)
        let y_type = s.y;
        (x_type, y_type)
    }
}


//# run 0xCAFE::TestAnonymousVar::test_shadowing_and_anonymous_vars --args true 0 12345u64


//# run 0xCAFE::TestAnonymousVar::match_struct --args 0


//# run 0xCAFE::TestAnonymousVar::closure_test


//# run 0xCAFE::TestAnonymousVar::call_with_address

// Featurres:
// f937f998c935ba5181a89daa92debdc1: Verify that the Move compiler correctly handles the use, scoping, shadowing, and pattern matching of the anonymous variable (_) in function arguments, local bindings, destructuring assignments, and closure parameters, including both valid and invalid usages.
// e0aab54c79f404bc763e4bcd3cd0821e: Invoke a named address with arguments as a call, like (SomeAddress()(argument)).
// a2d02fa47a7bef705ebad6a71fcda665: Perform type analysis on each field's base type within struct or variant layouts.
