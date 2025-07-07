
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_specific(x: u8, y: u8): u8 {
        let _sum = x + y;
        // Return specific value 42 to test addition logic is done
        42u8
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }
}



//# run 0xCAFE::TestAdd::add_and_return_specific --args 10u8 15u8



//# run 0xCAFE::TestAdd::use_lambda --args 5u8 6u8



//# publish
module 0xCAFE::MyModule {
    public inline fun f2(a: u16): (u16, u16) {
        // simple inline function returning two derived values for testing
        (a + 1, a + 2)
    }
}



//# publish
module 0xCAFE::TestInlineCall {
    // Removed unused use of TestAdd

    // Inline function that calls the inline function f2 from MyModule indirectly:
    // We recreate MyModule with only the inline function f2 to test calling inline function cross module here
    public inline fun f_mul_2(a: u16): (u16, u16) {
        // call MyModule::f2 and double the first value returned, triple second value returned
        let (p, q) = 0xCAFE::MyModule::f2(a);
        (p * 2, q * 3)
    }

    public fun call_inline_and_return_sum(a: u16): u64 {
        let (x, y) = f_mul_2(a);
        // Return sum as u64 for broader range
        (x as u64) + (y as u64)
    }
}



//# run 0xCAFE::TestInlineCall::call_inline_and_return_sum --args 10u16
