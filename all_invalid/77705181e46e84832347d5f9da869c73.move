
//# publish
module 0xCAFE::TestResourceInteraction {
    use std::vector;
    use std::error;
    use std::signer;
    use std::option::{Self, Option};
    use std::map::{Self, Map};
    use std::report::{Self, report_error};
    use std::debug;

    // Dummy resource to test resource safety violations
    struct ForbiddenResource {
        data: u64,
    }

    // Resource to be stored in the map
    struct Counter {
        count: u64,
    }

    // Struct that lacks proper resource acquisition annotations
    struct UnannotatedResource {
        value: u64,
    }

    // Store a ForbiddenResource in the account's global storage
    public fun store_forbidden_resource(account: &signer) {
        move_to<ForbiddenResource>(account, ForbiddenResource { data: 42 });
    }

    // Attempt to access ForbiddenResource without proper 'acquires' annotation
    public fun access_forbidden_resource_without_annotation(account: &signer) {
        let res_ref: &ForbiddenResource = borrow_global<ForbiddenResource>(signer::address_of(account));
        debug::print(&res_ref.data);
    }

    // Store Counter in a map by key
    public fun init_counter_in_map(map: &mut Map<u64, Counter>, key: u64) {
        let counter = Counter { count: 0 };
        map::insert(map, key, counter);
    }

    // Increment counter associated with key
    public fun increment_counter(map: &mut Map<u64, Counter>, key: u64) {
        let counter_ref: &mut Counter = map::borrow_mut(map, key);
        counter_ref.count = counter_ref.count + 1;
    }

    // Retrieve counter value for a key
    public fun get_counter_value(map: &Map<u64, Counter>, key: u64): u64 {
        let counter_ref: &Counter = map::borrow(map, key);
        counter_ref.count
    }

    // Initialize map in global storage
    public fun create_map(account: &signer): &mut Map<u64, Counter> {
        move_to<Map<u64, Counter>>(account, Map::new());
        let map_ref: &mut Map<u64, Counter> = borrow_global_mut<Map<u64, Counter>>(signer::address_of(account));
        map_ref
    }

    // Use report_error inside a spec expression with impure construct
    public fun report_error_example(x: u64): u64 {
        if (x > 10) {
            report_error(1); // Expect runtime or compile-time error
        };
        x
    }

    // Function that improperly accesses resource without proper 'acquires' annotation
    public fun access_unannotated_resource(account: &signer) {
        // No 'acquires' annotation in the signature
        let res_ref: &UnannotatedResource = borrow_global<UnannotatedResource>(signer::address_of(account));
        debug::print(&res_ref.value);
    }

    // Function that manipulates counters, triggers report_error in spec
    public fun complex_behavior(account: &signer, key: u64, trigger_error: bool) {
        // Resource safety check: no 'acquires' annotation for ForbiddenResource on this function
        // This should cause compile error if attempted (but not called here)
        // The map of counters
        let counters: &mut Map<u64, Counter>;
        if (!exists<Counter>(signer::address_of(account))) {
            counter_ptr = create_map(account);
        } else {
            counter_ptr = borrow_global_mut<Map<u64, Counter>>(signer::address_of(account));
        };

        // Increment counter for key
        increment_counter(counter_ptr, key);

        // Trigger report_error in a spec expression
        if (trigger_error) {
            report_error_example(42);
        };
    }
}

//# run 0xCAFE::TestResourceInteraction::access_forbidden_resource_without_annotation --signers 0xBADD --args

//# run 0xCAFE::TestResourceInteraction::access_unannotated_resource --signers 0xBADD

//# run 0xCAFE::TestResourceInteraction::complex_behavior --signers 0xBADD --args 3u64 false

//# run 0xCAFE::TestResourceInteraction::complex_behavior --signers 0xBADD --args 3u64 true


// Featurres:
// dc1da8d900c95d61ef4f1d8b18e8e32b: Receive compiler errors if a function accesses resources not listed in its 'acquires' annotation when inference is not available.
// c1f87a541029837d0a52204fd606080e: Store counters in a map associating keys to integer values
// d1fe34e1251d69a8bf49bb429293afee: Use the `report_error` function to generate an error when a specification expression tries to use an impure construct.
