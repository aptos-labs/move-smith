
//# publish
module 0xCAFE::AddModule {
    public fun add_two_and_return_nine(a: u8, b: u8): u8 {
        let sum = a + b;
        assert!(sum == (a + b), 1001);
        9u8
    }

    public fun store_lambda_and_call(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}



//# run 0xCAFE::AddModule::add_two_and_return_nine --args 3u8 4u8



//# run 0xCAFE::AddModule::store_lambda_and_call --args 5u8 7u8



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public fun call_inline_increment_and_add(a: u8, b: u8): u8 {
        let incremented_a = AddModule::inline_increment(a);
        let result = incremented_a + b;
        result
    }
}



//# run 0xCAFE::NestedCallModule::call_inline_increment_and_add --args 6u8 2u8



//# publish
module 0xCAFE::SameNamespaceUniqueNames {
    const CONST_VALUE_CONST: u8 = 100;

    public fun CONST_VALUE_FUN(): u8 {
        101u8
    }

    struct CONST_VALUE_STRUCT has copy, store, drop {
        val: u8
    }

    public fun create_struct(): CONST_VALUE_STRUCT {
        CONST_VALUE_STRUCT { val: 102 }
    }
}



//# run 0xCAFE::SameNamespaceUniqueNames::CONST_VALUE_FUN



//# run 0xCAFE::SameNamespaceUniqueNames::create_struct
