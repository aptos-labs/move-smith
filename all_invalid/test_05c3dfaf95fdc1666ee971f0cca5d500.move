//# publish
address 0x111 {
module 0x111::TestReassignCond {
    public fun reassign_cond_test(a: address, b: bool): address {
        if (b) {
            a = @0x999;
        };
        a
    }

    public fun test_reassign_cond_false() {
        let result = reassign_cond_test(@0x101, false);
        // No assertion, just to exercise the flow
    }
}
}

//# run 0x111::TestReassignCond::test_reassign_cond_false

//# publish
address 0x222 {
module 0x222::TestStructDestruct {
    struct InnerStruct {
        val: u64,
        flag: bool
    }

    public fun test_destruct_with_abort() {
        let inner = InnerStruct { val: 10, flag: true };
        abort 42;
        // Destructuring after abort should prevent this line from executing
        let InnerStruct { val, flag } = inner;
    }
}
}

//# run 0x222::TestStructDestruct::test_destruct_with_abort

//# publish
address 0x333 {
module 0x333::TestNestedRefMut {
    struct Nested {
        inner_value: u64,
        inner_flag: bool
    }

    struct Outer {
        nested: Nested
    }

    public fun mutate_nested_ref(o: &mut Outer) {
        let nested_ref = &mut o.nested;
        let Nested { inner_value, inner_flag } = nested_ref;
        *inner_value = *inner_value + 5;
        *inner_flag = !*inner_flag;
    }

    public fun test_nested_mut() {
        let mut outer = Outer { nested: Nested { inner_value: 100, inner_flag: true } };
        mutate_nested_ref(&mut outer);
        // No assertions, just the mutation
    }
}
}

//# run 0x333::TestNestedRefMut::test_nested_mut