
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u8, u8) {
        // Increment x and return as two u8 values
        ((x + 1) as u8, (x + 2) as u8)
    }
}

//# publish
module 0xCAFE::LambdaModule {
    const RETURN_VAL: u8 = 42;

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        let _lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let _ = _lambda(x, y);

        // Return a specified constant to confirm final output independent of sum
        RETURN_VAL
    }

    public fun call_inline() {
        let (a, b) = 0xCAFE::MyModule::f2(5u16);
        assert!(a == 6 && b == 7, 999);
    }

    // attr_name = 123]
    struct AnnotatedStruct has store {
        dummy: u8,
    }

    // attr_version = 1]
    public fun create_annotated_struct(): AnnotatedStruct {
        AnnotatedStruct { dummy: 0 }
    }
}



//# run 0xCAFE::LambdaModule::add_and_return --args 10u8 20u8



//# run 0xCAFE::LambdaModule::call_inline



//# run 0xCAFE::LambdaModule::create_annotated_struct
