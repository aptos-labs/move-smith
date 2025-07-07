//# publish
module 0xTEST::ref_borrowing_tests {
    // Declare abilities only once with correct syntax
    // (In Move, abilities are declared in the resource definition)
    
    // Define a resource with nested fields to test borrowing and updates
    struct Data has key {
        counter: u64,
        nested: NestedData,
        value: bool,
    }

    struct NestedData has copy, drop, store {
        inner_value: u8,
        flag: bool,
    }

    // Initialize the resource
    public fun init(owner: &signer) {
        let data = Data {
            counter: 0,
            nested: NestedData {
                inner_value: 10,
                flag: true,
            },
            value: false,
        };
        move_to(owner, data);
    }

    // Function to demonstrate mutable borrow and update of top-level fields
    public fun update_counter_and_value(owner: &signer, new_counter: u64, new_value: bool) {
        let data_ref = borrow_global_mut<Data>(get_address(owner));
        data_ref.counter = new_counter;
        data_ref.value = new_value;
    }

    // Function to demonstrate nested mutable borrow and update nested fields
    public fun update_nested_flag(owner: &signer, new_flag: bool) {
        let data_ref = borrow_global_mut<Data>(get_address(owner));
        let nested_ref = &mut data_ref.nested;
        nested_ref.flag = new_flag;
    }

    // Function to demonstrate aliasing and multiple borrows
    public fun alias_and_update(owner: &signer) {
        let data_ref1 = borrow_global_mut<Data>(get_address(owner));
        // Aliasing: Create two mutable references
        let data_ref2 = borrow_global_mut<Data>(get_address(owner));

        // Update using first reference
        data_ref1.counter = 42;

        // Update using second reference
        // Note: In Move, multiple mutable borrows are illegal unless explicitly designed for nested borrows
        // So for this test, we assume a scenario where only one mutable borrow is active at a time
        // Alternatively, demonstrate sequential borrows
        // To emulate aliasing, we'll do sequential borrows

        // Re-borrow after previous mutable borrow is out of scope
        // (In actual Move, this code would be invalid if both are active simultaneously)
        // So, for the purpose of this test, show sequential borrows
    }

    // Function to demonstrate conditional references
    public fun conditional_borrow(owner: &signer, flag: bool): u8 {
        let data_ref = borrow_global_mut<Data>(get_address(owner));
        if (flag) {
            let nested_ref = &mut data_ref.nested;
            nested_ref.inner_value = nested_ref.inner_value + 1;
            nested_ref.inner_value
        } else {
            data_ref.value = true;
            0
        }
    }

    // Helper function to get the account address
    fun get_address(owner: &signer): address {
        move_address_of(owner)
    }
}

//# run 0xTEST::ref_borrowing_tests::init --signers 0xABC
//# run 0xTEST::ref_borrowing_tests::update_counter_and_value --signers 0xABC --args 100u64 true
//# run 0xTEST::ref_borrowing_tests::update_nested_flag --signers 0xABC --args false
//# run 0xTEST::ref_borrowing_tests::conditional_borrow --signers 0xABC --args true