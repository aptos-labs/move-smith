
//# publish
module 0xCAFE::SpecModule {
    use std::vector;
    use std::signer;

    struct Container<T> has store, copy, drop {
        value: T
    }

    // Declare an invariant over a generic parameter with an invariant update and axiom
    spec module {
        // Correct syntax for forall with generics in Move spec:
        invariant forall<T> c: Container<T> {
            // Since Move spec does not support conditional type checks gracefully,
            // we restrict the invariant here only to u8 specifically:
            // Use type equality instead of exists<u8>:
            true
        }

        // We cannot specify conditional invariants with generic parameters currently.
        // So instead we declare the invariant specialized on Container<u8> only:
        invariant forall (c: Container<u8>) {
            c.value != 0
        }
        
        axiom forall<T> c: Container<T> {
            // This axiom states that the container's value equals itself
            // Trivial but tests axiom syntax with generics
            c.value == c.value
        }

        // Invariant update function that returns a new container with value incremented by 1 (requires u8)
        invariant_update fun increment_value(c: &mut Container<u8>) {
            c.value = c.value + 1;
        }
    }

    // test_only]
    // custom_attribute = "example"]
    public fun create_container_and_increment(x: u8): Container<u8> {
        let c = Container { value: x };
        // use the invariant update function (simulated by regular Move function here)
        Self::increment(&mut c);
        c
    }

    fun increment(c: &mut Container<u8>) {
        c.value = c.value + 1;
    }
}



//# run 0xCAFE::SpecModule::create_container_and_increment --args 10u8




//# publish
module 0xCAFE::NoCycle1 {
    struct S has copy, drop, store {
        a: u8
    }

    public fun make_s(x: u8): S {
        S { a: x }
    }
}




//# publish
module 0xCAFE::NoCycle2 {
    use 0xCAFE::NoCycle1;

    struct T has copy, drop, store {
        s: NoCycle1::S
    }

    public fun make_t(x: u8): T {
        let s = NoCycle1::make_s(x);
        T { s }
    }
}




//# run 0xCAFE::NoCycle1::make_s --args 7u8




//# run 0xCAFE::NoCycle2::make_t --args 7u8




//# publish
module 0xCAFE::CustomAttributeTest {
    // deprecated = "Use new_function instead"]
    public fun old_function(): u8 {
        1
    }

    // inline]
    // allow("custom-warning")]
    public fun new_function(): u8 {
        2
    }

    // custom_flag]
    // inline]
    public fun runner(): u8 {
        let a = Self::old_function();
        let b = Self::new_function();
        a + b
    }
}




//# run 0xCAFE::CustomAttributeTest::old_function




//# run 0xCAFE::CustomAttributeTest::new_function




//# run 0xCAFE::CustomAttributeTest::runner
