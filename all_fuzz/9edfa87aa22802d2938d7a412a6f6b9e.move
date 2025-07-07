
//# publish
module 0xCAFE::NativeAndErrorHandling {
    use std::signer;

    // Native layout struct example (simulate it by a struct with key ability)
    struct NativeStruct has key, store {
        id: u64,
        flag: bool,
    }

    public fun create_native_struct(s: signer, id: u64, flag: bool) {
        move_to<NativeStruct>(&s, NativeStruct { id, flag });
    }

    public fun read_native_struct(s: signer): (u64, bool) {
        let ns_ref = borrow_global<NativeStruct>(signer::address_of(&s));
        (ns_ref.id, ns_ref.flag)
    }

    // Function to simulate error diagnostics when encountering unexpected tokens
    // Here, we simulate by aborting with a custom error code if a list has unexpected tokens (simulated)
    public fun check_list_sanity(list: vector<u8>) {
        if (vector::length(&list) > 5) {
            // Pretend this is an error diagnostic for unexpected tokens
            abort 1001;
        };
    }

    // Serious diagnostics abort simulation
    public fun serious_check(val: u8) {
        if (val == 0) {
            // Serious error, terminate compilation by aborting
            abort 2002;
        };
    }

    public fun one(p: u8): u8 {
        p + 1
    }

    public fun test(p: u8): u8 {
        let _x = one(p);
        _x
    }
}


//# run 0xCAFE::NativeAndErrorHandling::create_native_struct --signers 0xDEAD --args 123u64 true


//# run 0xCAFE::NativeAndErrorHandling::read_native_struct --signers 0xDEAD


//# run 0xCAFE::NativeAndErrorHandling::check_list_sanity --args 1u8 2u8 3u8 4u8 5u8


//# run 0xCAFE::NativeAndErrorHandling::check_list_sanity --args 1u8 2u8 3u8 4u8 5u8 6u8


//# run 0xCAFE::NativeAndErrorHandling::serious_check --args 1u8


//# run 0xCAFE::NativeAndErrorHandling::serious_check --args 0u8


//# run 0xCAFE::NativeAndErrorHandling::test --args 7u8


// Featurres:
// 074ae3c89edcfec7941c10c61e51d9f0: Use the file format bytecode generated from stackless bytecode targets for deployment or execution.
// c9acf61f36353714d61a7351c74b1ede: Define structs with native layout.
// 3e0f2ec389d2f5a25651202c272a349e: Handle unexpected tokens within list elements by providing descriptive error messages.
// cf3f13457b85ef04d639f4adad79277b: Terminate compilation if serious diagnostics are encountered and reported
// 82192e1c5121e4531b7cb24f03120b62: Test that the `test` function correctly assigns the input parameter `p` to the local variable `_x` after calling the `one` function and returns the value of `_x`.
