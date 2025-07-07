
//# publish
module 0xCAFE::MyModule {
    // Define the struct Pair as public to allow other modules to access its fields
    struct Pair has copy, drop, store {
        pub x: u16,
        pub y: u16,
    }

    public fun f2(val: u16): Pair {
        Pair { x: val, y: val + 1 }
    }
}


//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8(a: u8, b: u8): u8 {
        let _c = a + b;
        // Return fixed value 42 to confirm function is called
        42u8
    }

    public fun call_lambda_and_add(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun nested_call(): u16 {
        let result = 0xCAFE::MyModule::f2(5u16);
        let x = result.x;
        let y = result.y;
        x + y
    }
}



//# run 0xCAFE::LambdaTest::add_u8 --args 10u8 20u8



//# run 0xCAFE::LambdaTest::call_lambda_and_add --args 7u8 8u8



//# run 0xCAFE::LambdaTest::nested_call
