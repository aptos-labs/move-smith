
//# publish
module 0xCAFE::LambdaAndInlineTest {

    // Removed the `use 0xCAFE::MyModule;` because the module does not exist,
    // and the problem statement forbids referencing 0xCAFE::MyModule.

    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            42u8
        } else {
            43u8
        }
    }

    public fun lambda_double_then_add(a: u8, b: u8): u8 {
        let double: |u8|u8 has copy+drop = |x: u8| {
            x + x
        };

        let add: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };

        let doubled_a = double(a);
        add(doubled_a, b)
    }

    //
    // Simulating the missing inline function by making `f2` a private helper function
    // inside the module (at module scope, not nested inside another function)
    //

    // Private helper function to simulate MyModule::f2(x: u16): (u16, u16)
    fun f2(x: u16): (u16, u16) {
        // Simple example logic: return (x, x * 2)
        (x, x * 2)
    }

    public fun call_my_module_inline(x: u16): u16 {
        let (first, second) = f2(x);
        first + second
    }
}



//# run 0xCAFE::LambdaAndInlineTest::add_then_return_fixed --args 30u8 20u8



//# run 0xCAFE::LambdaAndInlineTest::add_then_return_fixed --args 60u8 50u8



//# run 0xCAFE::LambdaAndInlineTest::lambda_double_then_add --args 10u8 5u8



//# run 0xCAFE::LambdaAndInlineTest::call_my_module_inline --args 100u16
