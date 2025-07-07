
//# publish
module 0xCAFE::LambdaModule {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            100u8
        } else {
            42u8
        }
    }

    public fun lambda_operations(x: u8, y: u8): (u8, u8) {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        let mul_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a * b };
        let sum = add_lambda(x, y);
        let product = mul_lambda(x, y);
        (sum, product)
    }
}



//# run 0xCAFE::LambdaModule::add_and_return_special --args 6u8 5u8



//# run 0xCAFE::LambdaModule::lambda_operations --args 4u8 3u8



//# publish
module 0xCAFE::InlineAndStructDestruct {
    use 0xCAFE::LambdaModule;

    struct DestructuredPair has copy, drop {
        first: u8,
        second: u8,
    }

    public fun call_inline_and_destruct(a: u8, b: u8): u8 {
        let (sum, product) = LambdaModule::lambda_operations(a, b);
        let DestructuredPair {second: prod, first: summation} = DestructuredPair {first: sum, second: product};
        let x = summation + prod;
        x
    }
}



//# run 0xCAFE::InlineAndStructDestruct::call_inline_and_destruct --args 2u8 3u8



//# publish
module 0xCAFE::PrivilegedModule {}



//# publish
module 0xCAFE::FriendAccessModule {
    friend 0xCAFE::PrivilegedModule;

    struct PrivStruct has store {
        value: u8,
    }

    public fun new_priv_struct(value: u8): PrivStruct {
        PrivStruct {value}
    }
}



//# publish
module 0xCAFE::PrivilegedModule {
    use 0xCAFE::FriendAccessModule;

    public fun read_priv_struct_val(ps: &FriendAccessModule::PrivStruct): u8 {
        ps.value
    }

    public fun privileged_get_value(value: u8): u8 {
        let priv_struct = FriendAccessModule::new_priv_struct(value);
        read_priv_struct_val(&priv_struct)
    }
}



//# run 0xCAFE::PrivilegedModule::privileged_get_value --args 123u8



//# publish
module 0xCAFE::AnnotationsTest {
    /// @initialized 10 100 true
    public fun annotated_function(x: u8): u8 {
        x + 1
    }
}



//# run 0xCAFE::AnnotationsTest::annotated_function --args 10u8
