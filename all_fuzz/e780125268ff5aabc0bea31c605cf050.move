
//# publish
module 0xCAFE::AdditionModule {
    public inline fun add_two_u8(x: u8, y: u8): u8 {
        x + y
    }

    struct InnerStruct has copy, drop, store {
        val: u8,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        flag: bool,
    }

    public fun make_outer_struct(x: u8, y: u8): OuterStruct {
        let sum = add_two_u8(x, y);
        let inner = InnerStruct { val: sum };
        OuterStruct { inner, flag: true }
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public inline fun call_addition_inline(x: u8, y: u8): u8 {
        AdditionModule::add_two_u8(x, y)
    }

    public fun call_make_outer_struct(x: u8, y: u8): AdditionModule::OuterStruct {
        AdditionModule::make_outer_struct(x, y)
    }
}


//# run 0xCAFE::AdditionModule::add_two_u8 --args 10u8 20u8


//# run 0xCAFE::AdditionModule::make_outer_struct --args 5u8 15u8


//# run 0xCAFE::CallerModule::call_addition_inline --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_make_outer_struct --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
