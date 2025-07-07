
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < 200) {
            42u8
        } else {
            255u8
        }
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    // Runner function that calls the other functions
    public fun run_tests(): (u8, u8) {
        let a = add_and_check(100u8, 50u8);
        let b = use_lambda(20u8, 30u8);
        (a, b)
    }
}




//# run 0xCAFE::AddAndLambda::run_tests




//# publish
module 0xCAFE::NestedInlineCaller {
    // Note: Move currently does not support cross-module import statements inside module body.
    // So remove `import` and call the function with fully qualified name.

    // This function calls AddAndLambda::add_and_check and uses its result,
    // then calls an inline function in AddAndLambda indirectly via run_tests.
    public fun call_add_and_lambda(a: u8, b: u8): u8 {
        let first_call = 0xCAFE::AddAndLambda::add_and_check(a, b);
        let (second_call, _) = 0xCAFE::AddAndLambda::run_tests();
        first_call + second_call
    }
}




//# run 0xCAFE::NestedInlineCaller::call_add_and_lambda --args 10u8 20u8
