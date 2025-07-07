
//# publish
module 0xCAFE::LambdaTest {
    // Removed unused import 'std::signer'
    
    public fun adder(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun lambda_example(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::LambdaTest::adder --args 3u8 7u8



//# run 0xCAFE::LambdaTest::lambda_example --args 5u8 6u8



//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }
}



//# publish
module 0xCAFE::CrossCallTest {
    use 0xCAFE::MyModule;

    public fun call_inline_f2(a: u16): (u16, u16) {
        let (x, y) = MyModule::f2(a);
        (x * 2, y * 2)
    }
}



//# run 0xCAFE::CrossCallTest::call_inline_f2 --args 11u16
