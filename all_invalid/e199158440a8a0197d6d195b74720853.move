
//# publish
module 0xCAFE::InferenceAndOrder {
    use std::vector;
    use std::debug;

    /// A dummy resource to test acquire inference
    struct R has store, key { val: u8 }

    /// Function that creates resource R at signer's address.
    /// No explicit 'acquires' annotation provided.
    public fun create_r(s: &signer, v: u8) {
        let r = R { val: v };
        move_to<R>(s, r);
    }

    /// Function that borrows resource R and returns its val field.
    /// No explicit 'acquires' annotation provided.
    public fun read_r(addr: address): u8 {
        let r_ref = borrow_global<R>(addr);
        r_ref.val
    }

    /// Function that converts a vector of (T, Ability vector) tuples to a vector of T only.
    /// Demonstrate conversion of list of type parameters with ability constraints to a "set-based" representation as a vector of the type names.
    /// Here T is vector<u8> to simplify.
    public fun convert_type_params(type_params_with_abilities: vector<(vector<u8>, vector<vector<u8>>)>) : vector<vector<u8>> {
        let result = vector::empty<vector<u8>>();
        let i = 0;
        while (i < vector::length(&type_params_with_abilities)) {
            let (type_name, _abilities) = *vector::borrow(&type_params_with_abilities, i);
            vector::push_back(&mut result, type_name);
            i = i + 1;
        };
        result
    }

    // Function_1: unique name function that returns u8
    public fun unique_function_one(x: u8): u8 {
        x + 10
    }

    // Function_2: unique name function that returns u8
    public fun unique_function_two(x: u8, y: u8): u8 {
        x * y
    }

    /// Functions to test evaluation order of function arguments with expression blocks

    /// A called function that records the argument values in debug logs.
    public fun called_function(a: u8, b: u8, c: u8): u8 {
        debug::print(&vector::concat(b"called_function args: ", vector::concat(debug::u8_to_bytes(a), vector::concat(b",", vector::concat(debug::u8_to_bytes(b), vector::concat(b",", debug::u8_to_bytes(c)))))));
        a + b + c
    }

    /// A helper function to be called inside expression blocks in arguments.
    /// It increments the input by 1.
    public fun increment(value: &mut u8): u8 {
        let old = *value;
        let new_val = old + 1;
        *value = new_val;
        new_val
    }

    /// Test function that uses expression blocks as arguments and checks that they run left to right.
    public fun test_expression_order(): u8 {
        let a = 0;
        // Call called_function with expression blocks as arguments
        // Each expression block increments a and returns its value.
        // The order must be left to right => a increments from 0 to 3 by the calls.
        let a_mut = a;
        let result = called_function(
            { increment(&mut a_mut) },
            { increment(&mut a_mut) },
            { increment(&mut a_mut) }
        );
        result + a_mut
    }
}



//# run 0xCAFE::InferenceAndOrder::create_r --signers 0xBEEF --args 42u8


//# run 0xCAFE::InferenceAndOrder::read_r --args 0xBEEF


//# run 0xCAFE::InferenceAndOrder::convert_type_params --args "(b\"TypeA\", vector[b\"key\", b\"copy\"])" "(b\"TypeB\", vector[b\"store\"])" "(b\"TypeC\", vector[b\"drop\", b\"copy\"])"


//# run 0xCAFE::InferenceAndOrder::unique_function_one --args 7u8


//# run 0xCAFE::InferenceAndOrder::unique_function_two --args 3u8 4u8


//# run 0xCAFE::InferenceAndOrder::test_expression_order
