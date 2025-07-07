//# publish
module 0xBADD::FilterModule {
    use std::vector;

    // A struct to test filtering capabilities
    struct DataItem has copy, drop, store, key {
        id: u64,
        value: u64,
        is_public: bool,
    }

    // A struct with optional field for filtering tests
    struct FilteredItem has copy, drop, store, key {
        item: DataItem,
        label: vector<u8>,
    }

    // Function to create DataItem
    public fun create_item(id: u64, value: u64, is_public: bool): DataItem {
        DataItem { id, value, is_public }
    }

    // Function to create FilteredItem
    public fun create_filtered_item(item: DataItem, label: vector<u8>): FilteredItem {
        FilteredItem { item, label }
    }

    // Function to get public fields if item is public
    public fun get_public_value(item: &DataItem): option<u64> {
        if (item.is_public) {
            option::some<u64>(item.value)
        } else {
            option::none<u64>()
        }
    }

    // Filtering logic: filter only items with even id and public
    public fun filter_public_even_ids(items: vector<DataItem>): vector<DataItem> {
        let filtered: vector<DataItem> = vector::empty<DataItem>();
        let i = 0;
        while (i < vector::length(&items)) {
            let item_ref = vector::borrow(&items, i);
            if (item_ref.id % 2 == 0 && item_ref.is_public) {
                vector::push_back(&mut filtered, *item_ref);
            }
            i = i + 1;
        };
        filtered
    }

    // Filtering logic with nested structures and aliasing
    public fun filter_with_aliasing(items: vector<DataItem>): vector<DataItem> {
        let filtered: vector<DataItem> = vector::empty<DataItem>();
        let len = vector::length(&items);
        let i = 0;
        while (i < len) {
            let item_ref = vector::borrow(&items, i);
            // Create alias (in Move, the borrows are immutable; for simulation, copy the value)
            let updated_item = *item_ref;
            // Update value if id is divisible by 3
            if (updated_item.id % 3 == 0) {
                updated_item.value = updated_item.value + 1000;
            }
            vector::push_back(&mut filtered, updated_item);
            i = i + 1;
        };
        filtered
    }
}



//# run 0xBADD::FilterModule::create_item --args 2u64 20u64 true


//# run 0xBADD::FilterModule::create_item --args 3u64 30u64 false


//# run 0xBADD::FilterModule::create_item --args 4u64 40u64 true


//# run 0xBADD::FilterModule::create_item --args 5u64 50u64 true



//# run 0xBADD::FilterModule::filter_public_even_ids --args [2u64, 3u64, 4u64, 6u64] 

// Prepare vector of items
// Note: The expected way to pass vector args in CLI is as a list of values, e.g. --args 2u64 3u64 4u64 6u64
// So the command should look like:
// # run 0xBADD::FilterModule::filter_public_even_ids --args 2u64 3u64 4u64 6u64

// The above are the main tests for filtering; now testing mutability and references

let item1 = 0xBADD::FilterModule::create_item(2, 200, true);
let item2 = 0xBADD::FilterModule::create_item(3, 300, false);
let item3 = 0xBADD::FilterModule::create_item(4, 400, true);
let item4 = 0xBADD::FilterModule::create_item(6, 600, true);

let items = vector::empty<DataItem>();
vector::push_back(&mut items, item1);
vector::push_back(&mut items, item2);
vector::push_back(&mut items, item3);
vector::push_back(&mut items, item4);

// Test readonly borrow and filtering
let filtered_items = 0xBADD::FilterModule::filter_public_even_ids(&items);

// Now test aliasing and mutation simulation
let filtered_aliasing = 0xBADD::FilterModule::filter_with_aliasing(&items);

// Testing that updates are reflected or handled properly
// e.g., check that item with id divisible by 3 has its value increased in filtered array
