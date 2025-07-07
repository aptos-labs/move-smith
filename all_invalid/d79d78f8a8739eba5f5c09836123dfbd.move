
//# publish
module 0xCAFE::TestControlFlow {
    use std::signer;
    use std::vector;

    // Function to test reassignemnt of a local mutable variable and returning its value
    public fun test_variable_reassignment(x: u8): u8 {
        let a = x;
        a = a + 5;
        a
    }

    // A nested struct for testing references and mutation
    struct OuterStruct has store {
        inner: InnerStruct,
    }

    struct InnerStruct has store {
        value: u64,
        nested: NestedStruct,
    }

    struct NestedStruct has store {
        count: u32,
        flag: bool,
    }

    // Function to test dereferencing and mutation of nested structs
    public fun test_nested_struct_mutation() {
        let nested = NestedStruct { count: 10, flag: false };
        let inner = InnerStruct { value: 1000, nested };
        let outer = OuterStruct { inner };

        // Borrow mutable reference to inner struct
        let inner_ref: &mut InnerStruct = &mut outer.inner;

        // Mutate fields via reference
        inner_ref.value = inner_ref.value + 500;
        inner_ref.nested.count = inner_ref.nested.count + 1;
        inner_ref.nested.flag = true;

        // Assert changes (via some dummy comparison; Move doesn't have assert with message)
        assert!(inner_ref.value == 1500, 101);
        assert!(inner_ref.nested.count == 11, 102);
        assert!(inner_ref.nested.flag == true, 103);
    }

    // Function to split critical edges in control flow (simulate multiple paths)
    public fun test_control_flow_branching(flag: bool): u16 {
        let result: u16 = 0;

        if (flag) {
            result = 1;
        } else {
            result = 2;
        };

        // split after branch for clearer analysis
        if (result == 1) {
            result = result + 10;
        } else {
            result = result + 20;
        };

        result
    }
}


//# run 0xCAFE::TestControlFlow::test_variable_reassignment --args 7u8
//

//# run 0xCAFE::TestControlFlow::test_nested_struct_mutation
//

//# run 0xCAFE::TestControlFlow::test_control_flow_branching --args true

// Featurres:
// b04526f301e24d01a4e5bb1cce3fe02d: Test that a function can reassign a local mutable variable and return its updated value.
// 1434c46b5ad1c098bf0160e364ed233d: Test that references to nested structs can be dereferenced and mutated correctly, and that changes persist as expected.
// 6d6cd2f7a5512a80ae044228facb41eb: Split critical edges in control flow graphs for better analysis and transformations.
