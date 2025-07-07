//# publish
module 0xCAFE::UnitTypeTest {
    use std::signer;

    // Define a struct with a unit type field
    struct UnitStruct has copy, drop, store {
        unit_field: (),
        nested: NestedStruct,
    }

    struct NestedStruct has copy, drop, store {
        value: u64,
    }

    public fun make_unit_struct(value: u64): UnitStruct {
        UnitStruct {
            unit_field: (),
            nested: NestedStruct { value }
        }
    }

    #[test(value = 42)]
    public fun test_unit_type_field(): () {
        // create a UnitStruct with nested.value = 42
        let us = make_unit_struct(42);
        // access nested.value with dotted expressions
        let nested_val = us.nested.value;
        // dummy usage to "use" the value (no assertion needed)
        let _ = nested_val;
    }

    #[test(value = 0)]
    public fun test_unit_type_field_update(): () {
        let mut us = make_unit_struct(0);
        // update nested.value by direct field access
        let nested_ref = &mut us.nested;
        nested_ref.value = 100;
    }

    // a "runner" function with no args
    public fun runner(): () {
        test_unit_type_field();
        test_unit_type_field_update();
    }
}
//# run 0xCAFE::UnitTypeTest::runner

//# publish
module 0xCAFE::DotAccess {
    struct Inner has copy, drop, store {
        a: u64,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
    }

    public fun new_outer(val: u64): Outer {
        Outer {
            inner: Inner {a: val}
        }
    }

    public fun get_inner_value(o: &Outer): u64 {
        o.inner.a
    }

    #[test(value = 7)]
    public fun dot_expression_test(): () {
        let outer = new_outer(7);
        let val = outer.inner.a;
        let val2 = get_inner_value(&outer);
        let _ = val + val2;
    }

    public fun runner(): () {
        dot_expression_test();
    }
}
//# run 0xCAFE::DotAccess::runner


//# run
script {
    use 0xCAFE::UnitTypeTest;
    use 0xCAFE::DotAccess;

    fun main() {
        UnitTypeTest::runner();
        DotAccess::runner();
    }
}

// Featurres:
// 1d057386bcda39af1f6c64e60c26b1f8: Define unit types using empty parentheses '()'.
// 323360c04f0fd067745b2d3cb5106e5e: Access nested fields or methods using dotted expressions in Move code
// 62c6bc5a7e6e9f9fb2f8575f5581c95f: Assign specific attribute values with the syntax `#[test(value = ...)]` to provide additional metadata for test functions.
