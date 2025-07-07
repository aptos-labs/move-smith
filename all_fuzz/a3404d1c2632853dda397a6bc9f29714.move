
//# publish
module 0xCAFE::MyModule {
    public inline fun f2(a: u16): (u16, u16) {
        // For example, returns (a, a*2)
        (a, a * 2)
    }
}


//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus 10 to differentiate
        sum + 10
    }

    public fun nested_inline_call(a: u16): u32 {
        // Calls the inline function f2 from 0xCAFE::MyModule and sums its components
        let (a1, a2) = 0xCAFE::MyModule::f2(a);
        (a1 + a2) as u32
    }
}



//# publish
module 0xCAFE::TestLambda {
    public fun run_lambda_add(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun run_lambda_process(a: u8): u8 {
        let lambda_process: |&u8| u8 has copy+drop = |r: &u8| {
            let val = *r;
            val * 2
        };
        lambda_process(&a)
    }
}



//# publish
module 0xCAFE::TestReferenceDereference {
    public fun deref_ref_and_return_value(a: u8): u8 {
        let r: &u8 = &a;
        *r + 5
    }
}



//# run 0xCAFE::TestAddition::add_and_return_sum --args 20u8 22u8



//# run 0xCAFE::TestAddition::nested_inline_call --args 3u16



//# run 0xCAFE::TestLambda::run_lambda_add --args 15u8 17u8



//# run 0xCAFE::TestLambda::run_lambda_process --args 12u8



//# run 0xCAFE::TestReferenceDereference::deref_ref_and_return_value --args 100u8
