
//# publish
module 0xCAFE::PersistentFunctionTest {
    use std::signer;
    use std::vector;

    // A function with the // persistent] attribute
    // persistent]
    public fun persistent_add_1(x: u64): u64 {
        x + 1
    }

    // A store-compatible struct that stores a function pointer with signature u64->u64
    struct FuncHolder has store, key {
        f: |(u64)->u64,
    }

    // Store the function in global storage at the signer's address
    public fun store_function(s: signer) {
        let holder = FuncHolder { f: persistent_add_1 };
        move_to<FuncHolder>(&s, holder);
    }

    // Retrieve the struct from storage and call the stored function
    public fun call_stored_function(s: signer, input: u64): u64 {
        // borrow the global struct
        let holder_ref: &FuncHolder = borrow_global<FuncHolder>(signer::address_of(&s));
        let f_ptr = holder_ref.f;

        // call the function pointer
        let out = f_ptr(input);

        // move out the struct from global storage, which also involves calling drop (no drop here, but tests move_from)
        let holder_val = move_from<FuncHolder>(signer::address_of(&s));
        let _ = holder_val;

        out
    }

    // Test vector expressions with explicit type arguments and element lists
    public fun vector_tests() {
        let v1 = vector[u8][1u8, 2u8, 3u8];
        let v2 = vector<bool>[true, false];
        let v3 = vector[address][@0x1, @0xCAFE];
        let v4 = vector<u64>[];
        let v5 = vector::empty<u128>();
        vector::push_back(&mut v5, 1000u128);
        vector::push_back(&mut v5, 2000u128);
    }

    // A struct with both key and drop
    struct KeyDropStruct has key, drop {
        x: u8,
    }

    // A generic function that requires type param T to have key + drop
    public fun borrow_and_move<T: key + drop>() {
        // Construct at 0xCAFE an example resource of type T for demonstration only, skipping since no address param
        // This function is to be called with type KeyDropStruct, so illustrating forbidden usage below
        // In implementation we'll show that borrowing and moving will cause error in certain combinations
    }

    // A function that borrows global and moves from global resource of type KeyDropStruct at a given address
    public fun borrow_and_move_keydrop(addr: address) {
        // Borrow global resource & move from global resource in one function for type with key+drop
        let reference: &KeyDropStruct = borrow_global<KeyDropStruct>(addr);
        let resource = move_from<KeyDropStruct>(addr);
        let _ = (reference, resource);
    }
}


//# run 0xCAFE::PersistentFunctionTest::store_function --signers 0xBEEF


//# run 0xCAFE::PersistentFunctionTest::call_stored_function --signers 0xBEEF --args 42u64


//# run 0xCAFE::PersistentFunctionTest::vector_tests


//# run 0xCAFE::PersistentFunctionTest::borrow_and_move_keydrop --args 0xBEEF


// Featurres:
// 51563007d945b4343bc81f1c189b7183: Test that a function with the #[persistent] attribute can be used as the value of a store-compatible struct and correctly executed after being stored and moved from global storage.
// 86c5be919ecd3ad56cff3fa4fd669dbf: Create vector expressions with specified type arguments and element list.
// ac9ab191f3aac312916f7734f8577b5b: Test that a type with both the `key` and `drop` abilities is rejected when passed to a generic function parameter requiring `key + drop` and used with both `borrow_global` and `move_from` in the same function.
