//# publish
module 0xCAFE::OptionalComma {
// Testing optional trailing commas in access specifiers
public(friend,) fun friend_function() {}

// A native entry function, no body here
native entry fun native_entry_function();

// vector construction tests
public fun test_vectors() {
    let v1 = vector[1, 2, 3];          // vector without type argument
    let v2: vector<u8> = vector[4u8, 5u8, 6u8, ]; // vector with trailing comma and type argument
    let v3: vector<u64> = vector[7u64, 8u64, 9u64]; // vector with type argument without trailing comma
    let v4 = vector[10, 11, 12, ];    // vector with trailing comma no type argument

    // Use the values for something trivial to not optimize away
    let a = *vector::borrow(&v1, 0);
    let b = *vector::borrow(&v2, 1);
    let c = *vector::borrow(&v3, 2);
    let d = *vector::borrow(&v4, 1);

    // dummy usage to avoid warnings about unused vars
    let _ = a + (b as u64) + c + (d as u64);
}

// runner function to call native entry function (which doesn't exist here, so dummy)
public fun runner() {
    // We cannot call native_entry_function here in normal Move code,
    // so just test vector and friend_function call.
    friend_function();
    test_vectors();
}
}
//# run 0xCAFE::OptionalComma::runner

//# run 0xCAFE::OptionalComma::native_entry_function --signers 0xCAFE

// Featurres:
// 7f11eead1c9592429aab953f8054c037: Allow optional trailing commas in access specifier lists.
// d50cf5731589eaf13d4298ccc60de113: Construct vectors using the 'vector' keyword with optional type arguments and a list of elements.
// 077541c853dad94d2381db12d33a4ad2: Mark native functions as 'entry' functions that can be invoked by transactions.
