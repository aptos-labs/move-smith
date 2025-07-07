
//# publish
module 0xCAFE::TestModule {
    // Testing script-call, variable scope inside loops, internal access, and asserts
    use std::signer;
    use std::vector;

    // Declare a version of the module for versioning test
    const MOVE_STD_VERSION: u8 = 2; // For example purposes

    // Define a resource with internal verification
    struct SecretResource has key {
        secret_value: u64,
    }

    // Internal function, should only be called within this module
    fun internal_increment(value: u64): u64 {
        value + 1
    }

    // Script entry point: invoke internal functions, test variable scoping and loop
    public fun run_tests(signer_addr: address) {
        // Step 1: Create a resource owned by signer
        // Correct way to get signer reference
        let signer_ref: &signer.Signer = signer::borrow_signer(&signer_addr);
        let secret = SecretResource { secret_value: 42 };
        move_to<SecretResource>(signer_ref, secret);

        // Step 2: Call internal function
        let _inside_call = internal_increment(100);

        // Step 3: Loop to test variable updates
        let i: u64 = 0;
        while (i < 5) {
            // Create another variable inside loop
            let local_counter: u64 = i;
            let local_counter = local_counter + 1;
            i = i + 1;
        };

        // Step 4: Check stored resource
        // Borrow the resource
        let res_borrowed: &SecretResource = borrow_global<SecretResource>(signer_addr);
        // Assert that secret_value is still correct
        assert!(exists<SecretResource>(signer_addr), 999);
        assert!(res_borrowed.secret_value == 42, 888);

        // Step 5: Attempt to call internal function from outside - should fail
        // (Commented out because it will cause compile error if uncommented)
        // let _fail_call = internal_increment(10);
    }
}



//# run 0xCAFE::TestModule::run_tests --signers 0xBADD --args 0xBADD



//# publish
module 0xCAFE::LoopAndExistenceTest {
    // Test: loops, exists expressions, and no shadowing
    use std::signer;
    use std::vector;

    // Resource with various values
    struct DataHolder has key {
        data_vec: vector<u8>,
        counter: u64,
    }

    // Entry script to test loop variables, existence, and assertions
    public fun main(signer_addr: address) {
        // Create resource
        let signer_ref: &signer.Signer = signer::borrow_signer(&signer_addr);
        move_to<DataHolder>(&signer_ref, DataHolder {
            data_vec: vector::empty<u8>(),
            counter: 0,
        });

        // Initialize variable outside loop
        let sum: u64 = 0;
        let i: u64 = 0;
        while (i < 10) {
            sum = sum + i;
            i = i + 2;
        };

        // Check that sum equals expected
        // sum of 0 + 2 + 4 + 6 + 8 = 20
        assert!(sum == 20, 777);

        // Use exists to verify resource presence
        assert!(exists<DataHolder>(signer_addr), 666);
        // Verify that a specific value exists in the resource data_vec
        // For simplicity, check that no elements (since empty), so should not exist
        let holder_ref: &DataHolder = borrow_global<DataHolder>(signer_addr);
        // Create an element inside data_vec
        let holder_mut_ref: &mut DataHolder = borrow_global_mut<DataHolder>(signer_addr);
        vector::push_back(&mut holder_mut_ref.data_vec, 99u8);
        // Now verify existence of 99 in data_vec
        let vec_ref: &vector<u8> = &holder_ref.data_vec;
        let exists_99 = vector::exists(vec_ref, |elem| *elem == 99u8);
        assert!(exists_99, 555);
    }
}
