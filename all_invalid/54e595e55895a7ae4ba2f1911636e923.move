
//# publish
module 0xC0FF::Registry {
    use std::vector;
    use std::option;

    struct WorkEntry has store, key {
        id: u64,
        work_value: u64,
    }

    struct Registry has store, key {
        entries: vector<WorkEntry>,
        total_work: u64,
    }

    public fun new_registry(): Registry {
        let entries = vector::empty<WorkEntry>();
        let total_work = 0u64;
        Registry { entries, total_work }
    }

    public fun add_work(registry: &mut Registry, id: u64, work_value: u64) {
        let entry = WorkEntry { id, work_value };
        vector::push_back(&mut registry.entries, entry);
        registry.total_work = registry.total_work + work_value;
    }

    public fun update_work(registry: &mut Registry, id: u64, new_work_value: u64) {
        let len = vector::length(&registry.entries);
        let i = 0u64;
        while (i < len) {
            let entry_ref = vector::borrow_mut(&mut registry.entries, i);
            if (entry_ref.id == id) {
                let old_value = entry_ref.work_value;
                entry_ref.work_value = new_work_value;
                registry.total_work = registry.total_work + new_work_value - old_value;
                break;
            }
            i = i + 1;
        }
    }

    public fun evaluate(registry: &Registry): u64 {
        // For simplicity, evaluation just returns the total work
        registry.total_work
    }

    public fun get_work_by_id(registry: &Registry, id: u64): option::Option<u64> {
        let len = vector::length(&registry.entries);
        let i = 0u64;
        while (i < len) {
            let entry_ref = vector::borrow(&registry.entries, i);
            if (entry_ref.id == id) {
                return option::some(entry_ref.work_value);
            };
            i = i + 1;
        };
        option::none()
    }
}



//# run 0xC0FF::Registry::new_registry --signers 0xBADC



//# run 0xC0FF::Registry::add_work --signers 0xBADC --args 1u64 10u64



//# run 0xC0FF::Registry::add_work --signers 0xBADC --args 2u64 20u64



//# run 0xC0FF::Registry::update_work --signers 0xBADC --args 1u64 15u64



//# run 0xC0FF::Registry::evaluate --signers 0xBADC



//# run 0xC0FF::Registry::get_work_by_id --signers 0xBADC --args 1u64


// Features:
// f900b94dca53be25721b14907d8740c3: Terminate expressions with tokens such as else, }, ), ,, :, or ; to indicate the end of an expression in your Move code.
// fff6da1af7f2555582182f8da47ddb58: Parse comma-separated lists of syntax elements with optional trailing commas.
// 3033ead783c591afb5847471fcbe56b3: Test that the registry correctly stores, updates, and retrieves delayed work functions, ensuring that the accumulated work is computed accurately over multiple add and eval operations.
