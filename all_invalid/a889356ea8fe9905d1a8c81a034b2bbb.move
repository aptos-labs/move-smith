
//# publish
module 0xBADD::TestBindingAndGroups {
    use std::vector;

    // Define a simple struct for binding test
    struct TestStruct has copy, drop, store {
        id: u64,
        data: vector<u8>,
    }

    // Function to test binding pattern with explicit field binding
    public fun bind_field_test(x: u8): u8 {
        let s = TestStruct {id: 123, data: vector::empty<u8>()};
        let TestStruct {id: bound_id, data: _} = s;
        // Use `bound_id` to verify the binding
        let v = vector::empty<u8>();
        vector::push_back(&mut v, bound_id as u8);
        // Return the first element in v for verification
        *vector::borrow(&v, 0)
    }

    // Function to test grouping items under address block
    public fun group_under_address_block() {
        // Directly create objects with address block
        address 0xCAFE {
            let obj = TestStruct {id: 999, data: vector::empty<u8>()};
            move_to<TestStruct>(&signer::borrow_global<signer>(@0xCAFE), obj);
        }
        address 0xBADD {
            let obj2 = TestStruct {id: 888, data: vector::empty<u8>()};
            move_to<TestStruct>(&signer::borrow_global<signer>(@0xBADD), obj2);
        }
    }

    // Function to verify dependency edges from vectors (module std::vector)
    // to external modules, explicitly or implicitly
    public fun verify_dependency_edges() {
        // Create vectors of different types to impose dependencies
        let v_u8 = vector::empty<u8>();
        let v_address = vector::empty<address>();
        let v_u64 = vector::empty<u64>();

        // Push some dummy data
        vector::push_back(&mut v_u8, 42);
        vector::push_back(&mut v_address, @0xCAFE);
        vector::push_back(&mut v_u64, 123456789u64);

        // Borrow to check
        let first_u8 = *vector::borrow(&v_u8, 0);
        let first_addr = *vector::borrow(&v_address, 0);
        let first_u64 = *vector::borrow(&v_u64, 0);

        // Simple asserts as placeholders for dependency check
        assert!(first_u8 == 42, 999);
        assert!(first_addr == @0xCAFE, 998);
        assert!(first_u64 == 123456789u64, 997);
    }

    // Runner function to run all subtests
    public fun run_all() {
        let _ = bind_field_test(10);
        group_under_address_block();
        verify_dependency_edges();
    }
}


//# run 0xBADD::TestBindingAndGroups::run_all


// Featurres:
// 0fbed9708c84f588fe7afa082275208c: Bind a field to a variable or a bind pattern in Move code
// 9986baa2a33f61eb2f2e619eeac50c94: Group Move items under address blocks using the 'address' construct.
// 1b8090c716e7400a1b3e5125a5644828: Automatically add dependency edges from modules outside the `vector` dependency closure to the `vector` module if it exists.
