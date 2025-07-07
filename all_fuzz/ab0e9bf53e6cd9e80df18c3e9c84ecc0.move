
//# publish
module 0xCAFE::TestModuleA {
    public fun add_two_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun run_lambda_example(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda(x, y)
    }

    public fun unpacking_examples(): (u8, u8, u8) {
        let (a, b) = (1u8, 2u8);
        let _c = 3u8;
        let _d = 4u8;
        let e = 5u8;
        (a, b, e)
    }
}




//# run 0xCAFE::TestModuleA::add_two_u8 --args 20u8 22u8




//# run 0xCAFE::TestModuleA::run_lambda_example --args 3u8 5u8




//# run 0xCAFE::TestModuleA::unpacking_examples





//# publish
module 0xCAFE::TestModuleB {
    use 0xCAFE::TestModuleA;

    public fun call_nested_inline(a: u8, b: u8): u8 {
        TestModuleA::add_two_u8(a, b)
    }
}




//# run 0xCAFE::TestModuleB::call_nested_inline --args 15u8 25u8
