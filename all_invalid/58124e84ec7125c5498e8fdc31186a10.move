
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
        let s = signer::borrow_address(&signer_addr);
        let secret = SecretResource { secret_value: 42 };
        move_to<SecretResource>(&signer::borrow_signer(&signer_addr), secret);

        // Step 2: Call internal function
        let _inside_call = internal_increment(100);

        // Step 3: Loop to test variable updates
        let i: u64 = 0;
        while (i < 5) {
            // Create another variable inside loop
            let local_counter = i;
            local_counter = local_counter + 1;
            i = i + 1;
        };

        // Step 4: Check stored resource
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
        move_to<DataHolder>(&signer::borrow_signer(&signer_addr), DataHolder {
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
        let _holder_ref: &DataHolder = borrow_global<DataHolder>(signer_addr);
        // Create an element inside data_vec
        let _ = vector::push_back(&mut borrow_global_mut<DataHolder>(signer_addr).data_vec, 99u8);
        // Now verify existence of 99 in data_vec
        let vec_ref = &borrow_global<DataHolder>(signer_addr).data_vec;
        // Build a boolean expression to check existence
        let exists_99 = vector::exists(vec_ref, |elem| *elem == 99u8);
        assert!(exists_99, 555);
    }
}


//# run 0xCAFE::LoopAndExistenceTest::main --signers 0xC0FF --args 0xC0FF


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 8c40c9a20785827b77fc8c0e29cf70ca: Write quantified expressions using 'exists' to assert the existence of values satisfying a condition.
// d938d95fe66bd7be7406382748283bef: Omit the unnecessary 'Self.' qualifier in your code.
// ba797e532fd77947e6356aeb125bcb79: Specify the language version for type checking compatibility.
