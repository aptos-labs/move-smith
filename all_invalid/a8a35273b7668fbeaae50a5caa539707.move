
//# publish
module 0xCAFE::GenericStorage {
    use std::vector;
    use std::signer;
    use std::string;

    // Struct with generic type parameter T, has store and key so it can be resource stored under an account
    struct Container<T> has store, key {
        items: vector<T>,
    }

    // Resource storing a generic function: |T|T with copy+drop abilities
    struct FunctionHolder<T> has store, key {
        f: (|T| T) 
    }

    // Store a Container<T> resource under signer address
    public fun create_container<T>(s: signer) {
        let cont = Container<T> { items: vector::empty<T>() };
        move_to<Container<T>>(&s, cont);
    }

    // Push an item into the Container<T> resource stored under signer address
    public fun push_item<T>(s: signer, item: T) {
        let cont_ref = borrow_global_mut<Container<T>>(signer::address_of(&s));
        vector::push_back(&mut cont_ref.items, item);
    }

    // Retrieve the length of items in Container<T>
    public fun container_len<T>(s: signer): u64 {
        let cont_ref = borrow_global<Container<T>>(signer::address_of(&s));
        vector::length(&cont_ref.items)
    }

    // Create a FunctionHolder<u8> resource with identity lambda |x| x stored under signer address
    public fun create_identity_fn_u8(s: signer) {
        let id_fn: (|u8| u8) has copy+drop = |x: u8| { x };
        let fh = FunctionHolder<u8> { f: id_fn };
        move_to<FunctionHolder<u8>>(&s, fh);
    }

    // Call the stored function in FunctionHolder<u8> resource with argument x and return result
    public fun call_identity_fn_u8(s: signer, x: u8): u8 {
        let fh_ref = borrow_global<FunctionHolder<u8>>(signer::address_of(&s));
        (fh_ref.f)(x)
    }

    // Check type equality via match on Container<T> resource
    // This function attempts to match Container<T> with Container<u8> and Container<u64>
    public fun check_type<T>(s: signer): u8 {
        let addr = signer::address_of(&s);
        // We cannot directly match on T, so we try to borrow resources of Container<u8> and Container<u64> at this address
        if (exists<Container<u8>>(addr)) {
            1
        } else if (exists<Container<u64>>(addr)) {
            2
        } else {
            0
        }
    }

    // Helper function to produce a string with a comma separated list of parameters and their types in Move syntax.
    // For demonstration, returns "param1: u8, param2: bool, param3: vector<u8>"
    public fun param_list_example(): vector<u8> {
        // b"param1: u8, param2: bool, param3: vector<u8>"
        b"param1: u8, param2: bool, param3: vector<u8>"
    }

    // Runner function that creates container<u8>, pushes some items, creates function holder, and calls it
    public fun runner(s: signer): u8 {
        create_container<u8>(s);
        push_item<u8>(s, 10u8);
        push_item<u8>(s, 20u8);
        create_identity_fn_u8(s);
        let len = container_len<u8>(s);
        let res = call_identity_fn_u8(s, 42u8);
        let typ = check_type<u8>(s);
        // Return res + len + typ (e.g. 42 + 2 + 1 = 45)
        res + len as u8 + typ
    }
}


//# run 0xCAFE::GenericStorage::runner --signers 0xBADD


//# run 0xCAFE::GenericStorage::param_list_example


//# run 0xCAFE::GenericStorage::check_type --signers 0xBADD


//# run 0xCAFE::GenericStorage::create_container<u64> --signers 0xDEAD


//# run 0xCAFE::GenericStorage::push_item<u64> --signers 0xDEAD --args 55u64


//# run 0xCAFE::GenericStorage::check_type<u64> --signers 0xDEAD


// Featurres:
// 9b265d2bf6b06a6082cc900e138e6587: Define modules containing structs with type parameters
// 0360f4b5cf74fca58cc71d4637178d07: Test that generic values—including function values with concrete generic types—can be stored, retrieved, and correctly matched for type equality in resources on-chain.
// 54439346b3ff0affe674c4e0fef60b6d: Generate a comma-separated list of function parameters with their types in Move syntax.
