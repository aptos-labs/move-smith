
//# publish
module 0xCAFE::CompilerInferenceTest {
    use std::signer;
    use std::vector;

    // Struct with key to test automatic acquires inference
    struct Data has key {
        val: u64,
        nums: vector<u8>,
    }

    // Create resource Data under signer's address
    public fun create_data(s: signer, init_val: u64, init_vec: vector<u8>) {
        let data = Data { val: init_val, nums: init_vec };
        move_to<Data>(&s, data);
    }

    // Function with multiple call arguments separated by commas in call
    public fun update_data_values(s: signer, new_val: u64, new_vec: vector<u8>, extra_val: u64) {
        let data_ref = borrow_global_mut<Data>(signer::address_of(&s));
        data_ref.val = new_val + extra_val;
        data_ref.nums = new_vec;
    }

    // Another function with unique name to test multiple functions in one module
    public fun increment_val(s: signer, amount: u64) {
        let data_ref = borrow_global_mut<Data>(signer::address_of(&s));
        data_ref.val = data_ref.val + amount;
    }

    // Function that calls other functions with multiple arguments separated by commas
    public fun batch_update(s: signer, a: u64, b: u64, v: vector<u8>) {
        // note the commas between arguments
        update_data_values(s, a, v, b);
        increment_val(s, b);
    }

    // Organizer struct with spec functions inside schema block
    struct Functions {}

    spec module {
        // Declare 'update' invariant: val should never decrease
        update invariant val_never_decreases(addr: address) {
            let data_opt = exists<Data>(addr);
            if (data_opt) {
                let data_ref = borrow_global<Data>(addr);
                data_ref.val >= old(data_ref).val
            } else {
                true
            }
        }
    }
}


//# run 0xCAFE::CompilerInferenceTest::create_data --signers 0xDEAD --args 10u64 x"1234"


//# run 0xCAFE::CompilerInferenceTest::update_data_values --signers 0xDEAD --args 20u64 x"5678" 5u64


//# run 0xCAFE::CompilerInferenceTest::increment_val --signers 0xDEAD --args 42u64


//# run 0xCAFE::CompilerInferenceTest::batch_update --signers 0xDEAD --args 100u64 10u64 x"abcd"


// Featurres:
// 9d49e7a08362804957d46bd9b9c8f757: Rely on the Move compiler to infer 'acquires' annotations automatically for functions in language version V2_2 or newer; you may omit them as they are not strictly required.
// 57d55d8653679e23d17052be8fcc17cc: Write multiple call arguments separated by commas.
// 8c99c7b1eb1a5c9c78bd6d603f35c4d8: Define functions with unique names in the same module
// 620f7ef42c99cf0f794972669396a24e: Automatically advance the token stream after checking the Move version.
// 3ad547c96786a64cd192079cf221dcfc: Add function members within a schema target of a module for organized code structure.
// d2481eaa11a9e5dd99ed461357bcfa99: Declare 'update' invariants in spec blocks to specify conditions that must hold after updates.
