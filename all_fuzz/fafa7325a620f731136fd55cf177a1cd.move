
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_then_return(x: u8, y: u8): u8 {
        let _sum = x + y;  // suppress unused binding warning
        // Return a fixed value after computing sum, to test calculation and return behavior
        42u8
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun runner(): u8 {
        let val = use_lambda(10u8, 20u8);
        val
    }
}



//# run 0xCAFE::AddAndLambda::add_then_return --args 15u8 25u8



//# run 0xCAFE::AddAndLambda::use_lambda --args 7u8 8u8



//# run 0xCAFE::AddAndLambda::runner




//# publish
module 0xCAFE::MyModule {
    // Provide a dummy function f2 that returns a tuple to replace the missing MyModule
    public fun f2(x: u16): (u16, u16) {
        // For example, split x into two halves or return fixed values
        (x / 2, x - (x / 2))
    }
}



//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::MyModule;

    public fun call_inline_and_process(x: u16): u16 {
        let (a, b) = MyModule::f2(x);
        a + b
    }

    public fun combined_runner(): u16 {
        call_inline_and_process(100u16)
    }
}



//# run 0xCAFE::CallInline::call_inline_and_process --args 50u16



//# run 0xCAFE::CallInline::combined_runner
