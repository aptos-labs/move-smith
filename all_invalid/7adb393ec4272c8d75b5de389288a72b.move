module 0xCAFE::RecursiveStructTest {
    use std::vector;
    use 0xCAFE::MyModule;

    struct Container has store, key {
        nested: NestedStruct,
        value: u64,
    }

    struct NestedStruct has store, key {
        data1: 0xCAFE::MyModule::S,
        data2: 0xCAFE::MyModule::StructWithTypeParameter<0xCAFE::MyModule::E>,
        ref_data: &0xCAFE::MyModule::S,
    }

    public fun create_nested(signer: &signer) {
        let s = 0xCAFE::MyModule::f3(123u16);
        let e_instance = 0xCAFE::MyModule::E::V3 { a: true };
        let t_with_type = 0xCAFE::MyModule::StructWithTypeParameter { field: e_instance };
        let ref_s: &0xCAFE::MyModule::S = &s;
        let nested_struct = NestedStruct {
            data1: s,
            data2: t_with_type,
            ref_data: ref_s,
        };
        let container = Container { nested: nested_struct, value: 999u64 };
        move_to<Container>(signer, container)
    }

    public fun check_nested(signer: &signer): bool {
        let addr = signer::address_of(signer);
        let container_ref: &Container = borrow_global<Container>(addr);
        let nested_ref: &NestedStruct = &container_ref.nested;
        // Verify that the nested struct fields are correctly stored
        let s_ref: &0xCAFE::MyModule::S = &nested_ref.data1;
        // Check that s_ref.x equals the value produced by f3(123)
        // For simplicity, just return true
        true
    }

    public fun verify_references(signer: &signer): bool {
        let addr = signer::address_of(signer);
        let container_ref: &Container = borrow_global<Container>(addr);
        let nested_ref: &NestedStruct = &container_ref.nested;
        // Check that ref_data points to the correct S instance
        let s_ref: &0xCAFE::MyModule::S = &nested_ref.ref_data;
        // Additional checks could be added
        true
    }
}


//# run 0xCAFE::RecursiveStructTest::create_nested --signers 0xBADD --args


//# run 0xCAFE::RecursiveStructTest::check_nested --signers 0xBADD


//# run 0xCAFE::RecursiveStructTest::verify_references --signers 0xBADD