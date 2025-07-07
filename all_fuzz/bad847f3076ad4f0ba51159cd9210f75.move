
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        let lambda: |u8| u8 = |z: u8| {
            let result = z + 10;
            result
        };
        lambda(sum)
    }

    public fun run_lambda_no_arg() {
        let anon: |u8, u8| u8 = |a: u8, b: u8| {
            a * b
        };
        let _result = anon(3u8, 4u8);
    }
}



//# run 0xCAFE::LambdaTest::add_then_return_fixed --args 5u8 7u8



//# run 0xCAFE::LambdaTest::run_lambda_no_arg



//# publish
module 0xCAFE::NestedInlineCaller {
    // Removed use of non-existent 0xCAFE::MyModule
    // Implement f2 directly or remove the call to MyModule::f2

    // Since the module 0xCAFE::MyModule does not exist, we define f2 here for demonstration
    public fun f2(x: u16): (u16, u16) {
        // For example, let's split x into two parts: half and half (or any dummy logic)
        let half = x / 2;
        (half, x - half)
    }

    public fun call_f2_and_add(a: u16, b: u16): u16 {
        let (x, y) = Self::f2(a);
        let (p, q) = Self::f2(b);
        x + y + p + q
    }
}



//# run 0xCAFE::NestedInlineCaller::call_f2_and_add --args 1u16 2u16
