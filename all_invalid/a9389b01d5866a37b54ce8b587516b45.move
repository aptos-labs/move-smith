
//# publish
module 0xCAFE::AnyAddressMutationControlFlow {
    use std::signer;

    // Struct that holds a simple u64 value, key to store under any address
    struct Data has store, copy, drop, key {
        val: u64,
    }

    // Struct with mutable field to test mutations
    struct ComplexData has store, key {
        counter: u64,
        flag: bool,
    }

    // Create and store Data resource at any address passed as generic addr param
    public fun create_data_at_any(addr: address, val: u64) {
        let signer_ref: &signer = signer::borrow_addr(addr);
        let data = Data { val };
        move_to<Data>(signer_ref, data);
    }

    // Read and return Data.val at any address; no mutation here
    public fun read_data_val(addr: address): u64 {
        let d_ref: &Data = borrow_global<Data>(addr);
        d_ref.val
    }

    // Mutate Data.val by incrementing it by add_val using compound assignment
    public fun add_to_data_val(addr: address, add_val: u64) {
        let d_mut_ref: &mut Data = borrow_global_mut<Data>(addr);
        d_mut_ref.val = d_mut_ref.val + add_val;
    }

    // Create ComplexData at any address with counter=init and flag=false
    public fun create_complex_data(addr: address, init: u64) {
        let signer_ref: &signer = signer::borrow_addr(addr);
        let cd = ComplexData { counter: init, flag: false };
        move_to<ComplexData>(signer_ref, cd);
    }

    // Mutate ComplexData.counter via simple assignment and compound assignments
    public fun mutate_complex_data_counter(addr: address) {
        let cd_mut_ref: &mut ComplexData = borrow_global_mut<ComplexData>(addr);
        cd_mut_ref.counter = 0;         // simple assignment
        cd_mut_ref.counter = cd_mut_ref.counter + 10; // compound addition
        cd_mut_ref.counter = cd_mut_ref.counter * 2;  // compound multiplication
    }

    // Set the flag field to true
    public fun set_flag_true(addr: address) {
        let cd_mut_ref: &mut ComplexData = borrow_global_mut<ComplexData>(addr);
        cd_mut_ref.flag = true;
    }

    // Loop increasing counter, break early when it reaches limit
    public fun loop_increment_with_break(addr: address, limit: u64) {
        let cd_mut_ref: &mut ComplexData = borrow_global_mut<ComplexData>(addr);
        loop {
            if (cd_mut_ref.counter >= limit) {
                break;
            };
            cd_mut_ref.counter = cd_mut_ref.counter + 1;
        };
    }

    // Early return if flag is true; otherwise increment counter once
    public fun early_return_on_flag(addr: address) {
        let cd_mut_ref: &mut ComplexData = borrow_global_mut<ComplexData>(addr);
        if (cd_mut_ref.flag) {
            // early return with no value
            return;
        };
        cd_mut_ref.counter = cd_mut_ref.counter + 1;
    }

    // Abort with specific code if counter exceeds threshold
    public fun abort_if_counter_too_big(addr: address, threshold: u64) {
        let cd_ref: &ComplexData = borrow_global<ComplexData>(addr);
        if (cd_ref.counter > threshold) {
            abort 1001;
        };
    }

    // Combined usage: mutate fields, in expression with early return and abort inside block
    public fun combined_mutation_control(addr: address, threshold: u64) {
        let cd_mut_ref: &mut ComplexData = borrow_global_mut<ComplexData>(addr);

        // Compound mutation with control flow inside
        if (cd_mut_ref.counter < threshold) {
            cd_mut_ref.counter = cd_mut_ref.counter + 1;
        } else {
            // Early return if hit threshold
            return;
        };

        // Abort if flag is true and counter is large
        if (cd_mut_ref.flag && cd_mut_ref.counter > threshold / 2) {
            abort 2002;
        };
    }

    // Runner function to exercise all features without arguments
    public fun runner() {
        let addr: address = @0xBEEF;

        // Create data under addr
        create_data_at_any(addr, 5);

        // Mutate Data val
        add_to_data_val(addr, 10);

        // Read and discard value
        let _val = read_data_val(addr);

        // Prepare ComplexData under addr
        create_complex_data(addr, 1);

        // Mutate counter field with assignments
        mutate_complex_data_counter(addr);

        // Loop increment counter with break limit 15
        loop_increment_with_break(addr, 15);

        // Set flag to true
        set_flag_true(addr);

        // Early return when flag true
        early_return_on_flag(addr);

        // Combined mutation and control flow with threshold 20
        combined_mutation_control(addr, 20);

        // Abort if counter too big (safe here, no abort expected)
        abort_if_counter_too_big(addr, 100);
    }
}



//# run 0xCAFE::AnyAddressMutationControlFlow::create_data_at_any --args 0xBEEF 100u64



//# run 0xCAFE::AnyAddressMutationControlFlow::add_to_data_val --args 0xBEEF 50u64



//# run 0xCAFE::AnyAddressMutationControlFlow::read_data_val --args 0xBEEF



//# run 0xCAFE::AnyAddressMutationControlFlow::create_complex_data --args 0xBEEF 3u64



//# run 0xCAFE::AnyAddressMutationControlFlow::mutate_complex_data_counter --args 0xBEEF



//# run 0xCAFE::AnyAddressMutationControlFlow::loop_increment_with_break --args 0xBEEF 10u64



//# run 0xCAFE::AnyAddressMutationControlFlow::set_flag_true --args 0xBEEF



//# run 0xCAFE::AnyAddressMutationControlFlow::early_return_on_flag --args 0xBEEF



//# run 0xCAFE::AnyAddressMutationControlFlow::combined_mutation_control --args 0xBEEF 20u64



//# run 0xCAFE::AnyAddressMutationControlFlow::abort_if_counter_too_big --args 0xBEEF 100u64



//# run 0xCAFE::AnyAddressMutationControlFlow::runner
