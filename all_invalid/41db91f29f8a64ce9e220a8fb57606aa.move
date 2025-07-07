
//# publish
module 0xCAFE::VarBindingAndGenerics {
    use std::vector;

    // Module with unbound variable names for binding tests
    struct UnboundVars has copy, drop, store {
        a: u64,
        b: bool,
        c: vector<u8>,
    }

    // Specification module containing constraints and assertions to merge
//# publish
module 0xCAFE::Specs {
    public fun check_constraints(x: u64, y: bool, data: vector<u8>) {
        assert!(x > 10, 999);
        assert!(y, 998);
        assert!(vector::length(&data) == 3, 997);
    }
}

// Module demonstrating generic structure with type parameters
struct GenericStruct<T> has copy, drop, store {
    value: T,
    description: vector<u8>,
}

// Function to instantiate generic struct with specific types
public fun instantiate_generics_with_u8(val: u8, desc: vector<u8>): GenericStruct<u8> {
    let gen = GenericStruct { value: val, description: desc };
    gen
}

public fun instantiate_generics_with_u64(val: u64, desc: vector<u8>): GenericStruct<u64> {
    let gen = GenericStruct { value: val, description: desc };
    gen
}

// Function to test variable binding, specifications, and generics
public fun test_binding_and_generics() {
    // Binding unbound variables to specific values
    let a_value = 42u64;
    let b_flag = true;
    let c_data = vector::empty<u8>();
    vector::push_back(&mut c_data, 1);
    vector::push_back(&mut c_data, 2);
    vector::push_back(&mut c_data, 3);

    // Instantiate structs with bound variables
    let unbound_instance = UnboundVars { a: a_value, b: b_flag, c: c_data };

    // Call specifications with bound variables
    0xCAFE::Specs::check_constraints(unbound_instance.a, unbound_instance.b, unbound_instance.c);

    // Instantiate generic structs with specific types
    let gen_u8 = instantiate_generics_with_u8(255, vector::empty<u8>());
    let gen_u64 = instantiate_generics_with_u64(12345678, vector::empty<u8>());

    // Additional assertions to verify instantiation
    assert!(gen_u8.value == 255, 1000);
    assert!(vector::length(&gen_u8.description) == 0, 1001);
    assert!(gen_u64.value == 12345678, 1002);
    assert!(vector::length(&gen_u64.description) == 0, 1003);
}


//# run 0xCAFE::VarBindingAndGenerics::test_binding_and_generics
