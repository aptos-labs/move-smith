
//# publish
module 0xBADD::InvariantTestModule {
    use std::vector;

    // Assume simple invariants with condition properties in spec.
    // These are just placeholders to exercise syntax; actual invariant checks are not formal here.
    struct Data has store, key {
        counter: u64,
        flag: bool,
    }

    public fun initialize_data(account: address, counter: u64, flag: bool) {
        let data = Data { counter, flag };
        move_to<Data>(&signer::borrow_address(&signer::new_signer(account)), data);
    }

    public fun update_counter(account: address, delta: u64) {
        let data_ref: &mut Data = borrow_global_mut<Data>(account);
        data_ref.counter = data_ref.counter + delta;
        // Control flow inside function
        if (data_ref.counter > 100) {
            data_ref.counter = 0;
        } else {
            // do nothing
        };
        // Always end with a semicolon
    }

    public fun toggle_flag(account: address) {
        let data_ref: &mut Data = borrow_global_mut<Data>(account);
        data_ref.flag = !data_ref.flag;
    }

    public fun control_flow_test(account: address, loop_count: u8) {
        let i = 0;
        while (i < (loop_count as u64)) {
            if (i % 2 == 0) {
                let _ = i;
            } else {
                let _ = i + 1;
            };
            i = i + 1;
        };
        // Use a loop to test control flow
        let j = 0;
        loop {
            if (j >= 3) {
                break;
            };
            j = j + 1;
        };
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


// Featurres:
// a871749d39b7d0f3b41f2eb092d92571: Add additional properties to invariants using condition properties syntax in spec blocks.
// a853f5fb5a697c8d86582f6705936d1f: Write control flow expressions such as 'if', 'while', and 'loop' statements within expressions.
// 19ce835471001d192c399996ca1ebb98: Address modules by account address or by address alias in module imports and references.
