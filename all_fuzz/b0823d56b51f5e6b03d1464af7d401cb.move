
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        let ret = if (sum > 10) { sum } else { 11u8 };
        ret
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_sum --args 5u8 6u8


//# publish
module 0xCAFE::ReferenceStructs {
    use 0xCAFE::AdditionModule;

    struct Inner has copy, drop, store {
        val: u8
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        added: u8,
    }

    public fun create_and_add(a: u8, b: u8): Outer {
        let inner = Inner { val: a };
        let added_val = AdditionModule::add_and_return_sum(a, b);
        Outer { inner, added: added_val }
    }

    public fun get_inner_val(o: &Outer): u8 {
        o.inner.val
    }

    public fun get_added_val(o: &Outer): u8 {
        o.added
    }
}


//# run 0xCAFE::ReferenceStructs::create_and_add --args 7u8 8u8


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::AdditionModule;

    public inline fun inline_add_twice(x: u8): u8 {
        let (a, b) = f_nested(x);
        a + b
    }

    public inline fun f_nested(x: u8): (u8, u8) {
        let a = AdditionModule::add_and_return_sum(x, 1u8);
        let b = AdditionModule::add_and_return_sum(x, 2u8);
        (a, b)
    }

    public fun call_inline(x: u8): u8 {
        inline_add_twice(x)
    }
}


//# run 0xCAFE::NestedInlineCall::call_inline --args 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
