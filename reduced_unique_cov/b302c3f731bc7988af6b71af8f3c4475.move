
//# publish
module 0xCAFE::QueueModule {
    use std::vector;
    use std::signer;

    // A generic queue struct for FIFO queue with copy+drop+store
    struct Queue<T: copy + drop + store> has store {
        items: vector<T>,
    }

    // Initialize an empty queue
    public fun new_queue<T: copy + drop + store>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    // Enqueue appends an item to the end
    public fun enqueue<T: copy + drop + store>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.items, item)
    }

    // Dequeue removes and returns the first item, abort code 1 if empty
    public fun dequeue<T: copy + drop + store>(queue: &mut Queue<T>): T {
        assert!(vector::length(&queue.items) > 0, 1);
        let first = *vector::borrow(&queue.items, 0);
        vector::remove(&mut queue.items, 0);
        first
    }

    // Runner function testing enqueue and dequeue order with u8 
    public fun runner_fifo_test(): bool {
        let q = new_queue<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let a = dequeue(&mut q);
        let b = dequeue(&mut q);
        let c = dequeue(&mut q);

        // We expect FIFO order: 10, 20, 30
        let is_fifo = (a == 10u8) && (b == 20u8) && (c == 30u8);
        is_fifo
    }
}


//# run 0xCAFE::QueueModule::runner_fifo_test



//# publish
module 0xCAFE::NestedModules {
    // Nested modules can be composed by multiple levels 
    // here we define deeply nested modules for demonstration
    // Level 1 module
//# publish
    module Level1 {
        pub const VALUE_1: u8 = 1;

        // Level 2 nested module inside Level1
//# publish
        module Level2 {
            pub const VALUE_2: u8 = 2;

            // Level 3 nested module inside Level2
//# publish
            module Level3 {
                pub const VALUE_3: u8 = 3;

                // Public function that returns sum of all LEVEL constants using module access chain
                public fun sum_constants(): u8 {
                    (Level1::VALUE_1) + (Level2::VALUE_2) + (Level3::VALUE_3)
                }
            }
        }
    }
}


//# run 0xCAFE::NestedModules::Level1::Level2::Level3::sum_constants



//# publish
module 0xCAFE::SingletonVariantWithRefs {
    use std::signer;

    // A struct with multiple abilities referencing other structs
    struct AddressHolder has store {
        addr: address,
    }

    struct Container<T: copy + drop + store> has key {
        inner: T,
    }

    // Singleton struct with a field referencing the Container<u64>
    struct Singleton has key {
        container_ref: Container<u64>,
    }

    // Enum with variant carrying a Container<AddressHolder>
    enum MyEnum has store, drop, copy {
        VariantWithRef(Container<AddressHolder>),
        UnitVariant,
    }

    public fun create_singleton_with_container(s: signer) {
        let container = Container<u64> { inner: 100u64 };
        let singleton = Singleton { container_ref: container };
        move_to<Singleton>(&s, singleton);
    }

    public fun create_enum_variant_with_container(): MyEnum {
        let addr_holder = AddressHolder { addr: @0xCAFE };
        let container = Container<AddressHolder> { inner: addr_holder };
        MyEnum::VariantWithRef(container)
    }
}


//# run 0xCAFE::SingletonVariantWithRefs::create_enum_variant_with_container



//# publish
module 0xCAFE::CombineAbilities {
    use std::signer;

    // A struct that requires copy+drop+store abilities for its type param
    struct DataStruct<T: copy + drop + store> has store {
        data: T,
    }

    // A public runner function that instantiates and returns DataStruct<u64>
    public fun runner_combine(): DataStruct<u64> {
        DataStruct<u64> { data: 42u64 }
    }
}


//# run 0xCAFE::CombineAbilities::runner_combine


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// 531270db1412b409e3b2e734b6fa50cf: Reference modules via module access chains, allowing composition of nested module paths.
