
//# publish
module 0xCAFE::NestedCalls {
    // A simple module exposing an inline function that adds two u8s
    public inline fun add_two(a: u8, b: u8): u8 {
        a + b
    }

    // Another inline function that calls add_two twice and returns their sum
    public inline fun nested_add(a: u8, b: u8, c: u8): u8 {
        let ab = add_two(a, b);
        let bc = add_two(b, c);
        ab + bc
    }
}



//# publish
module 0xCAFE::VariantRefModule {
    use std::option;
    use std::signer;

    struct InnerStruct has copy, drop, store {
        val: u8,
    }

    struct Wrapper has copy, drop, store {
        inner: InnerStruct,
    }

    enum ComplexEnum has drop, store {
        Variant1,
        Variant2 {
            w: Wrapper,
        }
    }

    public fun get_inner_val(e: &ComplexEnum): option::Option<u8> {
        match (e) {
            ComplexEnum::Variant1 => option::none<u8>(),
            ComplexEnum::Variant2 { w } => option::some<u8>(w.inner.val),
        }
    }

    // Creating a singleton struct with a field that references another type
    struct Singleton has key {
        wrapped: Wrapper,
    }

    public fun create_singleton(s: signer, val: u8) {
        let inner = InnerStruct { val };
        let wrapper = Wrapper { inner };
        move_to<Singleton>(&s, Singleton { wrapped: wrapper });
    }

    public fun borrow_singleton_val(s: signer): u8 {
        let singleton_ref = borrow_global<Singleton>(signer::address_of(&s));
        singleton_ref.wrapped.inner.val
    }
}



//# publish
module 0xCAFE::CallInlineTester {
    use 0xCAFE::NestedCalls;

    // Function calls the inline nested_add function and also calls it twice nestedly
    public fun test_nested_calls(a: u8, b: u8, c: u8): u8 {
        let basic = NestedCalls::nested_add(a, b, c);
        let double_nested = NestedCalls::nested_add(basic, basic, basic);
        double_nested
    }
}




//# run 0xCAFE::NestedCalls::add_two --args 3u8 5u8


//# run 0xCAFE::NestedCalls::nested_add --args 3u8 4u8 5u8


//# run 0xCAFE::VariantRefModule::create_singleton --signers 0xBEEF --args 123u8


//# run 0xCAFE::VariantRefModule::borrow_singleton_val --signers 0xBEEF


//# run 0xCAFE::CallInlineTester::test_nested_calls --args 2u8 3u8 4u8
