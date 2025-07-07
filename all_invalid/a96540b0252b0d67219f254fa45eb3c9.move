
//# publish
module 0xDEAD::TestModule {
    use std::vector;

    struct DataResource has store, key {
        counter: u64,
        value: bool,
    }

    public fun initialize_resource(signer: signer, initial_counter: u64, initial_value: bool) {
        let resource = DataResource { counter: initial_counter, value: initial_value };
        move_to<DataResource>(&signer, resource);
    }

    public fun mutate_counter(s: &signer, delta: u64) {
        let resource_ref: &mut DataResource = borrow_global_mut<DataResource>(signer::address_of(s));
        resource_ref.counter = resource_ref.counter + delta;
    }

    public fun mutate_value(s: &signer, new_value: bool) {
        let resource_ref: &mut DataResource = borrow_global_mut<DataResource>(signer::address_of(s));
        resource_ref.value = new_value;
    }

    public fun get_resource(s: &signer): (u64, bool) {
        let resource_ref: &DataResource = borrow_global<DataResource>(signer::address_of(s));
        (resource_ref.counter, resource_ref.value)
    }

    public fun delete_resource(s: &signer) {
        move_from<DataResource>(signer::address_of(s));
    }

    // Inline functions to test nested function calls and target attributes
    public inline fun inline_increment(x: u64): u64 {
        let y = x + 1;
        y
    }

    public fun call_inline(s: &signer, amount: u64): u64 {
        // target: Inline target attribute
        inline_increment(amount)
    }

    // Function with control flow to test spec blocks and mutation
    public fun control_flow_test(s: &signer, condition: bool, increment: u64): u64 {
        // target: If statement
        if (condition) {
            // target: mutate counter in resource
            mutate_counter(s, increment);
            let (cnt, val) = get_resource(s);
            cnt
        } else {
            // target: mutate value in resource
            mutate_value(s, true);
            let (_cnt, val) = get_resource(s);
            if (val) {
                // target: nested if
                mutate_value(s, false);
            };
            // last expression
            let (_cnt, val2) = get_resource(s);
            if (val2) {
                0
            } else {
                1
            }
        }
    }

    // Function with a loop to test iteration with mutation
    public fun loop_test(s: &signer, times: u64): u64 {
        let i = 0;
        // target: loop
        loop {
            if (i >= times) {
                break;
            };
            mutate_counter(s, 1);
            i = i + 1;
        };
        let (cnt, _) = get_resource(s);
        cnt
    }

    // Function with a while loop to test while construct
    public fun while_test(s: &signer, max: u64): u64 {
        let total = 0;
        // target: while
        while (total < max) {
            mutate_counter(s, 2);
            total = total + 2;
        };
        total
    }

    // Function with nested spec blocks for mutability and target
    public fun nested_spec_blocks(s: &signer, start: u64): u64 {
        // target: first spec block
        {
            // target: mutation inside first spec
            mutate_counter(s, start);
            let (cnt, _) = get_resource(s);
            cnt
        }
    }
}


//# run 0xDEAD::TestModule::initialize_resource --signers 0xC0DE --args 0u64 false


//# run 0xDEAD::TestModule::call_inline --signers 0xC0DE --args 5u64


//# run 0xDEAD::TestModule::control_flow_test --signers 0xC0DE --args true 10u64


//# run 0xDEAD::TestModule::control_flow_test --signers 0xC0DE --args false 20u64


//# run 0xDEAD::TestModule::loop_test --signers 0xC0DE --args 3u64


//# run 0xDEAD::TestModule::while_test --signers 0xC0DE --args 15u64


//# publish
module 0xBADA::ScriptTester {
    use 0xDEAD::TestModule;
    use std::signer;

    public fun run_mutability_sequence(signer_addr: address) {
        let s = signer::borrow_signer(&signer_addr);

        // Sequentially mutate resource
        TestModule::initialize_resource(&s, 0, false);
        // target: mutate counter
        TestModule::mutate_counter(&s, 10);
        // target: mutate value
        TestModule::mutate_value(&s, true);
        // verify
        let (cnt, val) = TestModule::get_resource(&s);
        // post-mutation, expected counter=10, value=true
        //delete resource to clean up
        TestModule::delete_resource(&s);
    }

    // Function calling nested inline
    public fun run_inline_call(signer_addr: address) {
        let s = signer::borrow_signer(&signer_addr);
        let val = TestModule::call_inline(&s, 7);
        // val should be 8
        // cleanup
        TestModule::delete_resource(&s);
    }

    // Function to test control flow mutations
    public fun run_control_flow(signer_addr: address) {
        let s = signer::borrow_signer(&signer_addr);
        TestModule::initialize_resource(&s, 0, false);
        let res1 = TestModule::control_flow_test(&s, true, 15);
        let res2 = TestModule::control_flow_test(&s, false, 0);
        // cleanup
        TestModule::delete_resource(&s);
    }

    // Loop and nested spec block test
    public fun run_loop_and_spec(signer_addr: address) {
        let s = signer::borrow_signer(&signer_addr);
        TestModule::initialize_resource(&s, 0, false);
        let total = TestModule::loop_test(&s, 4);
        let total2 = TestModule::while_test(&s, 6);
        let nested_res = TestModule::nested_spec_blocks(&s, 42);
        // cleanup
        TestModule::delete_resource(&s);
    }
}


//# run 0xBADA::ScriptTester::run_mutability_sequence --signers 0xBADD

//# run 0xBADA::ScriptTester::run_inline_call --signers 0xBADD

//# run 0xBADA::ScriptTester::run_control_flow --signers 0xBADD

//# run 0xBADA::ScriptTester::run_loop_and_spec --signers 0xBADD


// Featurres:
// 1249ce86d777852c3ca977dcfb335bf6: Attach specification blocks to specific Move language constructs using the 'target' mechanism.
// 34378d7af0b0a616c5620c09c7adbe27: Mutate data with `FieldMutate` and `Mutate` expressions.
// 477f6a0d7e3e657c8ff5d179eb8af0c8: Declare scripts with associated function names.
