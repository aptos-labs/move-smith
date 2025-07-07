//# publish
module 0xA::ResourceTest {

    // Define a resource that will be stored in an account
    struct Data has key {
        value: u64,
        label: vector<u8>,
    }

    // A helper for borrowing the resource immutably
    inline fun borrow_data(): &Data {
        borrow_global<Data>(@0xA)
    }

    // A function to test that resource can be stored, borrowed, and accessed
    public fun test_storage_borrow_and_access(account: &signer) acquires Data {
        move_to<Data>(account, Data { value: 42, label: vector::empty<u8>() });
        let data_ref = borrow_data();
        // Perform some logic with the resource
        assert!(data_ref.value == 42, 42);
        // Optionally, check the label length
        assert!(vector::length(&data_ref.label) == 0, 0);
    }

    // A runner function to initialize the test
    public fun run_test() {
        // No arguments needed
    }
}

//# run --signers 0xA
script {
    use 0xA::ResourceTest;
    fun main(account: &signer) {
        ResourceTest::test_storage_borrow_and_access(&account);
    }
}