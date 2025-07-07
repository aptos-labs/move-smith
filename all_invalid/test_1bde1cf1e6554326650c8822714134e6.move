//# publish
module 0x99::test_module {
    // A simple resource to store a number
    struct Number has key {
        value: u64,
    }

    // Initialize the resource with a specific value
    public fun initialize(account: &signer, init_value: u64) {
        move_to(account, Number { value: init_value });
    }

    // Function to update the stored number
    public fun update_value(addr: address, new_value: u64) acquires Number {
        let num = &mut borrow_global_mut<Number>(addr);
        num.value = new_value;
    }

    // Function to get the current value
    public fun get_value(addr: address): u64 acquires Number {
        let num = &borrow_global<Number>(addr);
        num.value
    }

    // A callback that modifies the resource and returns a string
    public fun callback_modify(addr: address, delta: u64): String acquires Number {
        let num = &mut borrow_global_mut<Number>(addr);
        num.value += delta;
        String::from_utf8(b"Modified").unwrap()
    }
}

//# run 0x99::test_module::initialize --signers 0x99 --args 42u64

//# run 0x99::test_module::get_value --args @0x99

//# run 0x99::test_module::callback_modify --signers 0x99 --args @0x99 11u64

//# run 0x99::test_module::get_value --args @0x99

// Additional test: Initialize a resource, invoke a callback that modifies it, then verify the expected value
//# run 0x99::test_module::update_value --signers 0x99 --args @0x99 23u64

//# run 0x99::test_module::get_value --args @0x99
