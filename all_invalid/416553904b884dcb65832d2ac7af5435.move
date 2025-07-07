




#define NESTED_VECTOR constant vector<vector<u8>> = vector[
    vector![1u8, 2u8], 
    vector![3u8, 4u8]
];

declare constant CONSTANT_VECTOR: vector<vector<u8>> = NESTED_VECTOR;

// This function performs a map over nested vectors, applying a closure that references outer variables.
public fun test_vector_map() {
    let outer_capture = 10u8;
    let result = vector::map< vector<u8>, vector<u8> >(CONSTANT_VECTOR, |inner_vec: &vector<u8>| {
        // Map each inner vector to a new vector where each element is added with outer_capture.
        vector::map<u8, u8>(inner_vec, |elem: &u8| {
            *elem + outer_capture
        })
    });
    // result is a vector<vector<u8>> where each inner vector has been incremented by 10.
}

// 3. Display local variable names (name disambiguation), using the symbol pool (simulated).
// Since Move's symbol pool isn't directly accessible, simulate by assigning variable names explicitly and capturing their debug info.

public fun test_symbol_pool_display() {
    let local_a = 42u64;
    let local_b = true;
    let local_c = b"hello";

    // The purpose is to demonstrate variable usage; in actual compiler output, names are preserved.
    // Here, just define variables so that tools inspecting debug info see these.
    let _a_name = "local_a";
    let _b_name = "local_b";
    let _c_name = "local_c";
}


test_vector_map();
test_symbol_pool_display();

// End of test


// Featurres:
// a9bf1eb4cc5818ed2292a8a12504cc12: Retrieve the module's identifier (address and name) after deserialization.
// 37878dfc8ef016009d536159cf2eea24: Test that vector::map works correctly when applied to nested vectors stored in constants and that closures within map can reference their arguments and perform computations.
// f4615cb3e06b36e24c5094c7a3104352: Display local variable names using the symbol pool to get human-readable names.
