
//# publish
module 0xCAFE::AddAndLambda {
    // Removed the dependency on the non-existing MyModule so it compiles and runs independently

    public fun add_two_u8s(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100
        } else {
            sum
        }
    }

    public fun test_lambda_identity(x: u8): u8 {
        let identity: |u8| u8 has copy+drop = |y: u8| y;
        identity(x)
    }

    // replicate inline function f2 here (assuming f2(a:u16): (u16, u16) returning something simple)
    // since MyModule does not exist, define inline function in this module to simulate behavior
    // inline]
    fun f2(a: u16): (u16, u16) {
        (a * 2, a + 1)
    }

    public fun nested_inline_call(a: u16): u32 {
        let (u, _) = f2(a);
        u as u32
    }

    public fun test_mut_ref_immutable_copy() {
        let original = 10u8;
        let copied = copy original;
        let mut_ref: &mut u8 = &mut original;
        *mut_ref = 20u8;

        // copied should remain unchanged
        assert!(copied == 10, 100);
        assert!(original == 20, 101);
    }
}



//# run 0xCAFE::AddAndLambda::add_two_u8s --args 30u8 40u8



//# run 0xCAFE::AddAndLambda::test_lambda_identity --args 123u8



//# run 0xCAFE::AddAndLambda::nested_inline_call --args 15u16



//# run 0xCAFE::AddAndLambda::test_mut_ref_immutable_copy
