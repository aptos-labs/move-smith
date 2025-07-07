
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // Provide a local implementation of f2 since 0xCAFE::MyModule is not available.
    // Mimics a function that takes a u16 and returns a tuple of (u16, u16).
    fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    struct Wrapper has copy, drop, store {
        value: u8
    }

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignore = sum; // bind to wildcard to test ignore
        42u8
    }

    public fun lambda_usage(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| { a + b };
        let mul = |a: u8, b: u8| { a * b };

        let sum = add(x, y);
        let prod = mul(x, y);

        // tuple types are not allowed as local variable types, so don't assign to tuple variable
        // use the values directly without combining into a tuple
        let _unused_sum = sum;
        let _unused_prod = prod;
        sum
    }

    public fun nested_inline_call(x: u16): u32 {
        let (a, b) = f2(x);
        let sum = a + b;
        sum as u32
    }

    public fun var_assign_and_shadowing(x: u8): u8 {
        let x = x + 1;
        let x = x * 2;
        x
    }

    public fun wildcard_binding_test(): u8 {
        let (a, _) = f2(5u16);
        let Wrapper {value: _} = Wrapper {value: a as u8};
        a as u8
    }

    public fun increments_and_accesses(): u8 {
        // Increments for primitive
        let primitive = 0u8;
        let primitive = primitive + 1;

        // Struct increment field
        let w = Wrapper {value: 1};
        let w = Wrapper { value: w.value + 1 };

        // Vector increment element
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 2);
        let val_ref = vector::borrow_mut(&mut v, 0);
        *val_ref = *val_ref + 1;

        primitive + w.value + *vector::borrow(&v, 0)
    }

    public fun dummy() {}
}




//# run 0xCAFE::FeatureTest::add_two_values --args 10u8 15u8




//# run 0xCAFE::FeatureTest::lambda_usage --args 4u8 5u8




//# run 0xCAFE::FeatureTest::nested_inline_call --args 7u16




//# run 0xCAFE::FeatureTest::var_assign_and_shadowing --args 3u8




//# run 0xCAFE::FeatureTest::wildcard_binding_test




//# run 0xCAFE::FeatureTest::increments_and_accesses
