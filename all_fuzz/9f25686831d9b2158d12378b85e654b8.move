
//# publish
module 0xCAFE::AdditionModule {
    const RETURN_MAGIC: u8 = 42;

    public fun add_and_return_magic(a: u8, b: u8): u8 {
        let sum = a + b;
        sum;
        RETURN_MAGIC
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    struct Data has store, copy, drop {
        value: u8,
    }

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }

    public fun create_data(x: u8): Data {
        Data { value: x }
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_magic --args 10u8 32u8



//# run 0xCAFE::AdditionModule::with_lambda --args 10u8 5u8



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    const CONST_A: u8 = 11;

    struct NestedData has store {
        field: u8,
    }

    public fun nested_runner(): u8 {
        let v = AdditionModule::inline_double(CONST_A);
        let result = AdditionModule::add_and_return_magic(v, 1u8);
        result
    }

    public fun create_nested_data(): NestedData {
        NestedData { field: CONST_A }
    }
}



//# run 0xCAFE::NestedCallModule::nested_runner



//# publish
module 0xCAFE::AllFeatures {
    use 0xCAFE::AdditionModule;

    friend 0xCAFE::NestedCallModule;

    const CONSTANT_VALUE: u8 = 77;

    struct FeatureData has store, copy, drop {
        x: u8,
    }

    public fun run_feature(data: FeatureData): u8 {
        let val = AdditionModule::add_and_return_magic(data.x, CONSTANT_VALUE);
        val
    }

    public fun create_feature_data(x: u8): FeatureData {
        FeatureData { x }
    }
}



//# run 0xCAFE::AllFeatures::run_feature --args 5u8
