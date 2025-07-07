//# publish
module 0xAB::test_resource_management {

    // Use a resource with a primitive field to test global resource interactions and mutations
    struct Status has key {
        active: bool
    }

    // Initialize the resource at a given address
    fun init_status(s: &signer) {
        move_to(s, Status { active: true });
    }

    // Function to toggle the 'active' flag
    fun toggle_status(addr: address) acquires Status {
        let status_ref = borrow_global_mut<Status>(addr);
        status_ref.active = !status_ref.active;
    }

    // Function to reset the status to active
    fun reset_status(addr: address) acquires Status {
        let status_ref = borrow_global_mut<Status>(addr);
        status_ref.active = true;
    }

    // Resource with vector and borrow operations
    struct Collection has key {
        items: vector<u64>
    }

    // Initialize collection at address
    fun init_collection(s: &signer) {
        move_to(s, Collection { items: vector[] });
    }

    // Add elements to the collection
    fun add_element(addr: address, val: u64) acquires Collection {
        let coll = borrow_global_mut<Collection>(addr);
        vector::push_back(&mut coll.items, val);
    }

    // Remove last element from collection
    fun remove_last(addr: address) acquires Collection {
        let coll = borrow_global_mut<Collection>(addr);
        assert!(vector::length(&coll.items) > 0, 1);
        vector::pop_back(&mut coll.items);
    }

    // Borrow a vector reference and mutate
    fun mutate_vector(addr: address) acquires Collection {
        let coll = borrow_global_mut<Collection>(addr);
        let len = vector::length(&coll.items);
        if (len > 0) {
            let first = &mut coll.items[0];
            *first = *first + 100;
        }
    }

    // Inter-module interaction: Utilizing a module to process a resource
    struct Processor has key {
        processed: bool
    }

    fun init_processor(s: &signer) {
        move_to(s, Processor { processed: false });
    }

    fun process_resource(addr: address) acquires Processor {
        let processor = borrow_global_mut<Processor>(addr);
        processor.processed = true;
    }

    // Resource with nested Borrows and Drop semantics
    struct Container has key {
        value: u64
    }

    fun init_container(s: &signer, val: u64) {
        move_to(s, Container { value: val });
    }

    fun modify_container(addr: address, new_val: u64) acquires Container {
        let container = borrow_global_mut<Container>(addr);
        container.value = new_val;
    }

    // Testing mutations with helper functions
    fun double_value(addr: address) acquires Container {
        let container = borrow_global_mut<Container>(addr);
        container.value = container.value * 2;
    }

}

//# run --signers 0x1 -- 0xAB::test_resource_management::init_status
//# run -- 0xAB::test_resource_management::toggle_status --args 0x1
//# run -- 0xAB::test_resource_management::reset_status --args 0x1
//# run --signers 0x2 -- 0xAB::test_resource_management::init_collection
//# run -- 0xAB::test_resource_management::add_element --args 0x2 42
//# run -- 0xAB::test_resource_management::add_element --args 0x2 100
//# run -- 0xAB::test_resource_management::remove_last --args 0x2
//# run --signers 0x3 -- 0xAB::test_resource_management::init_processor
//# run -- 0xAB::test_resource_management::process_resource --args 0x3
//# run --signers 0x4 -- 0xAB::test_resource_management::init_container
//# run -- 0xAB::test_resource_management::modify_container --args 0x4 555
//# run -- 0xAB::test_resource_management::double_value --args 0x4