
//# publish
module 0xCAFE::VariableVectorGenericInteraction {
    use std::vector;

    // Struct with a generic type parameter
    struct Container<T> has copy, drop, store {
        value: T,
    }

    // A function returning a vector of u64
    public fun get_u64_vector(): vector<u64> {
        let v = vector::empty<u64>();
        vector::push_back(&mut v, 100);
        vector::push_back(&mut v, 200);
        vector::push_back(&mut v, 300);
        v
    }

    // A function returning a vector of address
    public fun get_address_vector(): vector<address> {
        let v = vector::empty<address>();
        vector::push_back(&mut v, @0xBEEFBEEF);
        vector::push_back(&mut v, @0xDEADBEEF);
        v
    }

    // A function creating and using a vector of a generic struct
    public fun get_struct_vector<T>(val: T): vector<Container<T>> {
        let v = vector::empty<Container<T>>();
        let c = Container { value: val };
        vector::push_back(&mut v, c);
        v
    }

    // Test variable declaration before if-else with all branches covering return paths
    public fun test_variable_before_if(x: u8, y: bool): u8 {
        let result;
        if (y) {
            result = 10u8;
        } else {
            result = 20u8;
        };
        result
    }

    // Test vector variable declared outside and used inside conditional
    public fun test_vector_usage(flag: bool): u64 {
        let v: vector<u64>;
        if (flag) {
            v = get_u64_vector();
        } else {
            v = vector::empty<u64>();
            vector::push_back(&mut v, 999);
        };
        // Return the length of v
        let len = vector::length(&v);
        len
    }

    // Test instantiation of generic struct and interaction with vectors
    public fun test_generic_structs(some_value: address): address {
        let struct_vec: vector<Container<address>> = get_struct_vector(some_value);
        // Access first element
        let first: &Container<address> = vector::borrow(&struct_vec, 0);
        first.value
    }

    // Test variable declaration with vector of address, and use in control flow
    public fun test_address_vector_in_flow(addr1: address, addr2: address, pick: bool): address {
        let v: vector<address>;
        if (pick) {
            v = get_address_vector();
        } else {
            v = vector::empty<address>();
            vector::push_back(&mut v, addr1);
        };
        // Borrow first address
        let first_addr = *vector::borrow(&v, 0);
        first_addr
    }
}

//# run 0xCAFE::VariableVectorGenericInteraction::test_variable_before_if --args 5u8 true


//# run 0xCAFE::VariableVectorGenericInteraction::test_variable_before_if --args 5u8 false


//# run 0xCAFE::VariableVectorGenericInteraction::test_vector_usage --args true


//# run 0xCAFE::VariableVectorGenericInteraction::test_vector_usage --args false


//# run 0xCAFE::VariableVectorGenericInteraction::test_generic_structs --signers 0xBADD --args 0xCAFEBABE


//# run 0xCAFE::VariableVectorGenericInteraction::test_address_vector_in_flow --args 0xABC123 0xDEF456 true


//# run 0xCAFE::VariableVectorGenericInteraction::test_address_vector_in_flow --args 0xABC123 0xDEF456 false


// Featurres:
// f592f715445dc4b59d133d0ac40d4069: Test that the compiler allows variable declarations before an if-else where all return paths are covered, even if the variable is only initialized in one branch and not used before the return.
// a231dc4d27bf992781ad062e3287d6ee: Create vector types with element type specifications using 'vector<type>' syntax.
// e731d714e7696e38c4992a86138da242: Define struct type parameters for generic types.
