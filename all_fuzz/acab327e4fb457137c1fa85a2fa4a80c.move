
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_42(x: u8, y: u8): u8 {
        let _sum = x + y;
        // ignore sum, just return 42
        42u8
    }

    public fun test_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::TestAdd::add_and_return_42 --args 10u8 20u8



//# run 0xCAFE::TestAdd::test_lambda --args 12u8 13u8



//# publish
module 0xCAFE::InlineCaller {
    // Removed invalid `use` of example module MyModule

    public fun f2(a: u16): (u16, u16) {
        // A dummy implementation to avoid linker error, 
        // since MyModule is not available, implement f2 here.
        (a, a + 1)
    }

    public fun call_f2_and_return_sum(a: u16): u16 {
        let (b, c) = Self::f2(a);
        b + c
    }
}



//# run 0xCAFE::InlineCaller::call_f2_and_return_sum --args 5u16
