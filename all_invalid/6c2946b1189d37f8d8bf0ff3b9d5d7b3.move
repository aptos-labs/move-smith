
//# publish
module 0xBADD::InvariantTestModule {
    use std::vector; // Warning: unused, but kept if needed later

    // Import signer module - ensure correct import path if needed
    use std::signer;

    // Assume simple invariants with condition properties in spec.
    // These are just placeholders to exercise syntax; actual invariant checks are not formal here.
    struct Data has store, key {
        counter: u64,
        flag: bool,
    }

    public fun initialize_data(account: address, counter: u64, flag: bool) {
        // Correct way to get a signer from an address
        let s = signer::new_signer(account);
        move_to<Data>(&s, Data { counter, flag });
    }

    public fun update_counter(account: address, delta: u64) {
        let data_ref: &mut Data = borrow_global_mut<Data>(account);
        data_ref.counter = data_ref.counter + delta;
        // Control flow inside function
        if (data_ref.counter > 100) {
            data_ref.counter = 0;
        } else {
            // do nothing
        }
        // end with a semicolon (redundant here, but good practice)
    }

    public fun toggle_flag(account: address) {
        let data_ref: &mut Data = borrow_global_mut<Data>(account);
        data_ref.flag = !data_ref.flag;
    }

    public fun control_flow_test(account: address, loop_count: u8) {
        let i: u64 = 0;
        while (i < (loop_count as u64)) {
            if (i % 2 == 0) {
                let _ = i;
            } else {
                let _ = i + 1;
            }
            i = i + 1;
        }
        // Use a loop to test control flow
        let j: u64 = 0;
        loop {
            if (j >= 3) {
                break;
            }
            j = j + 1;
        }
    }

    // Helper to get data object for testing
    public fun get_data(account: address): Data {
        borrow_global<Data>(account)
    }
}



//# run 0xBADD::InvariantTestModule::initialize_data --signers 0xABCD --args 0u64 false



//# run 0xBADD::InvariantTestModule::update_counter --signers 0xABCD --args 50u64



//# run 0xBADD::InvariantTestModule::toggle_flag --signers 0xABCD



//# run 0xBADD::InvariantTestModule::control_flow_test --signers 0xABCD --args 10u8



//# run 0xBADD::InvariantTestModule::get_data --signers 0xABCD
