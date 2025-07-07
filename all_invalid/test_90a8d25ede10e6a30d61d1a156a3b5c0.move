//# publish
module 0x55::closure_trait_test {
    struct ClosureStruct has drop {
        callback: fn(&u64) -> bool,
    }

    fun create_closure() : ClosureStruct {
        let closure: fn(&u64) -> bool = |x| *x % 2 == 0;
        ClosureStruct { callback: closure }
    }

    fun test_closure() {
        let cs = create_closure();
        let input = &3u64;
        let result = (cs.callback)(input);
        assert!(!result, 0);
        let even_input = &4u64;
        let result_even = (cs.callback)(even_input);
        assert!(result_even, 1);
    }
}

//# run 0x55::closure_trait_test::test_closure

//# publish
module 0x55::nested_structs_mut {
    struct InnerStruct has drop {
        value: u64,
    }

    struct OuterStruct has drop {
        inner: InnerStruct,
        flag: bool,
    }

    fun mutate_inner() {
        let mut outer = OuterStruct {
            inner: InnerStruct { value: 10 },
            flag: false,
        };
        // Access inner struct via reference
        let OuterStruct { inner: ref mut inner_ref, flag: _ } = &mut outer;
        // Mutate inner struct
        inner_ref.value = inner_ref.value + 5;

        // Verify mutation
        assert!(outer.inner.value == 15, 0);
        outer.inner.value = outer.inner.value + 10;
        assert!(outer.inner.value == 25, 1);
        // Change flag
        outer.flag = true;
        assert!(outer.flag, 2);
    }
}

//# run 0x55::nested_structs_mut::mutate_inner