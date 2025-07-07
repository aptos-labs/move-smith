
//# publish
module 0xCAFE::QueueModule {
    use std::vector;
    use std::option;

    // A simple FIFO queue of u64
    struct Queue has store {
        items: vector<u64>,
    }

    public fun create(): Queue {
        Queue { items: vector::empty<u64>() }
    }

    public fun enqueue(queue: &mut Queue, item: u64) {
        vector::push_back(&mut queue.items, item);
    }

    public fun dequeue(queue: &mut Queue): option::Option<u64> {
        if (vector::is_empty(&queue.items)) {
            option::none<u64>()
        } else {
            let item = *vector::borrow(&queue.items, 0);
            let len = vector::length(&queue.items);
            let new_items = vector::empty<u64>();
            let i = 1;
            while (i < len) {
                vector::push_back(&mut new_items, *vector::borrow(&queue.items, i));
                i = i + 1;
            };
            queue.items = new_items;
            option::some(item)
        }
    }

    // Wrap a call to a function f() from another module 0xCAFE::InlineCaller that calls inline functions.
    public fun test_inline_call(x: u16): (u16, u16) {
        0xCAFE::InlineCaller::call_f2(x)
    }

    // Convert an optional vector<u8> to vector<u8> - 
    // if the option is none, return empty vector, else the inner vector.
    public fun option_vector_to_vector(opt_vec: option::Option<vector<u8>>): vector<u8> {
        match (opt_vec) {
            option::Option::None => vector::empty<u8>(),
            option::Option::Some(inner_vec) => inner_vec,
        }
    }

}


//# publish
module 0xCAFE::ComplexTypes {
    use std::string;
    use std::address;

    // Variant struct with a reference to address type field
    struct RefStruct has store {
        owner: address,
        label: string::String,
    }

    // Singleton struct holding one RefStruct
    struct Singleton has key {
        inner: RefStruct,
    }

    public fun create_singleton(owner: address, label: string::String): Singleton {
        Singleton { inner: RefStruct { owner, label } }
    }
}


//# publish
module 0xCAFE::InlineCaller {
    // Inline function that will be called from other modules
    public inline fun f2(a: u16): (u16, u16) {
        (a + 10, a + 20)
    }

    // Public function that calls the inline function f2 internally
    public fun call_f2(a: u16): (u16, u16) {
        f2(a)
    }
}


//# run
script {
    use 0xCAFE::QueueModule;
    use std::option;

    fun main() {
        let q = QueueModule::create();

        // Enqueue numbers 1, 2, 3
        QueueModule::enqueue(&mut q, 1);
        QueueModule::enqueue(&mut q, 2);
        QueueModule::enqueue(&mut q, 3);

        // Dequeue three times and verify FIFO order implicitly by runtime
        let x1 = QueueModule::dequeue(&mut q);
        let x2 = QueueModule::dequeue(&mut q);
        let x3 = QueueModule::dequeue(&mut q);

        // Dequeue once more should return None
        let x4 = QueueModule::dequeue(&mut q);

        // Now test inline call within QueueModule
        let res = QueueModule::test_inline_call(5u16);

        // Test option vector to vector conversion with Some variant
        let v1 = vector[42u8, 43u8, 44u8];
        let opt_vec_some = option::some(v1);
        let v_res_some = QueueModule::option_vector_to_vector(opt_vec_some);

        // Test option vector to vector conversion with None variant
        let opt_vec_none: option::Option<vector<u8>> = option::none();
        let v_res_none = QueueModule::option_vector_to_vector(opt_vec_none);

        // Create ComplexTypes::Singleton instance
        let addr = @0xBEEF;
        let label = b"test_label";
        let s = 0xCAFE::ComplexTypes::create_singleton(addr, label);

    }
}


//# run 0xCAFE::QueueModule::test_inline_call --args 7u16


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 085c33951ebc169114c2f748af63cf0f: Convert an optional vector of Move types to a vector of internal representation types, facilitating the translation of optional type annotations into internal compiler types.
