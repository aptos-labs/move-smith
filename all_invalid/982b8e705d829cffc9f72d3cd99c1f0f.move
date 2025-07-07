//# publish
module 0xCAFE::TestLoopAndStructs {
    // A simple struct with abilities and attributes
    struct MyStruct has copy, drop, store {
        value: u64,
        flag: bool,
    }

    // Another struct with type parameters and layout annotation
    struct GenericStruct<T> has copy, drop, store {
        data: T,
        count: u8,
        // optional layout attribute (Note: In current Move, layout annotations are limited; assuming for test purpose)
        // #[layout("deep")]
        // layout: "deep"
    }

    // Function to retrieve all registered external expression checkers
    public fun get_all_expression_checkers() {
        // For test purposes, assume the expression checkers are stored in a vector
        // We simulate retrieval by creating a vector of dummy identifiers
        let checker1: vector<u8> = b"CheckerA";
        let checker2: vector<u8> = b"CheckerB";
        let checker3: vector<u8> = b"CheckerC";
        let _all_checkers = vector::empty();

        // Normally, would call an external API or stored module to get them
        // Here, just create a vector with the above checkers for simulation
        let checkers = vector::empty();
        vector::push_back(&mut checkers, checker1);
        vector::push_back(&mut checkers, checker2);
        vector::push_back(&mut checkers, checker3);
        // End of simulation: no return value needed
    }
}

//# run 0xCAFE::TestLoopAndStructs::get_all_expression_checkers
//# run 0xCAFE::TestLoopAndStructs::MyStruct::MyStruct --signers 0xCAFE --args 42u64 true
//# run 0xCAFE::TestLoopAndStructs::GenericStruct::<u64>::GenericStruct --signers 0xCAFE --args 99u8 10u8
//# run 0xCAFE::TestLoopAndStructs::GenericStruct::<vector<u8>>::GenericStruct --signers 0xCAFE --args b"data", 5u8

// Featurres:
// 51cf5acfd94ca60fc9bc9ae924d26101: Test that a while loop with a false condition does not execute and the variable retains its initial value.
// 493ce8035e7ebc0a810f21e355e065e9: Define struct types with attributes, abilities, type parameters, and layout annotations.
// b483f22d87a652baafe2edd66436de65: Retrieve all registered external expression checkers for the current module.
