
//# publish
module 0xBABE::NestedStructs {
    struct InnerStruct has copy, drop, store {
        a: u64,
        b: u64,
    }

    struct MiddleStruct has copy, drop, store {
        inner: InnerStruct,
        c: u64,
    }

    struct OuterStruct has copy, drop, store {
        middle: MiddleStruct,
        d: u64,
    }

    public fun create_outer(): OuterStruct {
        let inner = InnerStruct {a: 10, b: 20};
        let middle = MiddleStruct {inner: inner, c: 30};
        let outer = OuterStruct {middle: middle, d: 40};
        outer
    }

    public fun get_nested_inner_a(outer: &OuterStruct): u64 {
        let inner_ref = &outer.middle.inner;
        inner_ref.a
    }

    public fun get_nested_middle_c(outer: &OuterStruct): u64 {
        let middle_ref = &outer.middle;
        middle_ref.c
    }
}


//# run 0xBABE::NestedStructs::create_outer --args 

//# run 0xBABE::NestedStructs::get_nested_inner_a --args 0x1

//# run 0xBABE::NestedStructs::get_nested_middle_c --args 0x1


//# publish
module 0xDEAD::VariableScopeTest {
    // Internal function with restricted visibility
    fun internal_increment(_x: &mut u64) {
        *(_x) = *_(_x) + 1;
    }

    public fun run_internal_increment(x: &mut u64) {
        internal_increment(x);
    }
}


//# run 0xDEAD::VariableScopeTest::run_internal_increment --args 0x1


//# publish
module 0xBEEF::ShadowVariableTest {
    public fun shadowing_test() {
        let a: u64 = 100;
        let outer_a = a;

        // Variable declared outside the loop
        let _b = 0;

        let i = 0;
        while (i < 3) {
            // Shadowing variable 'a' inside the loop
            let a = i;
            // Access outer 'a' to confirm it's unchanged
            assert!(outer_a == 100, 999);
            // Modify shadowed 'a'
            let _ = a + 1;
            // Shadowing 'b' variable in inner block
            {
                let _b = i * 2;
            };
            i = i + 1;
        };
        // After loop, verify that 'a' variable is unchanged
        assert!(a == 100, 888);
        // _b remains unaffected outside if used; but in move, since shadowed, not accessible
    }
}


//# run 0xBEEF::ShadowVariableTest::shadowing_test


//# publish
module 0xC0FFEE::ComplexInteraction {
    use 0xBABE::NestedStructs;

    // Internal function with restricted visibility
    fun internal_compute(value: &mut u64) {
        *value = *value * 2;
    }

    // Public function to test complex nested field access and variable shadowing
    public fun complex_test() {
        let outer = NestedStructs::create_outer();

        // Access nested inner field and modify
        let inner_a = NestedStructs::get_nested_inner_a(&outer);
        inner_a = inner_a + 100;

        // Shadow variable inside block
        let outer_a = inner_a;
        {
            let outer_a = outer_a + 50;
            // Call internal function with shadowed variable
            internal_compute(&mut outer_a);
            // Assert within block
            assert!(outer_a == (outer.a + 150) * 2, 777);
        };
        // After block, verify outer variable remains unaffected
        assert!(outer_a == inner_a + 50, 776);
    }
}


//# run 0xC0FFEE::ComplexInteraction::complex_test


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
