
//# publish
module 0xCAFE::Queue {
    use std::vector;
    use std::signer;

    // 2. Struct with a field referencing another type
    struct Node<T> has copy, drop, store {
        value: T,
        next: Option<u64>,
    }

    struct Queue<T> has store {
        head: Option<u64>,
        tail: Option<u64>,
        nodes: vector<Node<T>>,
    }

    // Combine abilities for the generic type parameter
    public fun new<T has copy+drop>(): Queue<T> {
        Queue {
            head: Option::none(),
            tail: Option::none(),
            nodes: vector::empty<Node<T>>(),
        }
    }

    public fun enqueue<T has copy+drop>(queue: &mut Queue<T>, item: T) {
        let node = Node {
            value: item,
            next: Option::none(),
        };
        let idx = vector::length(&queue.nodes);
        vector::push_back(&mut queue.nodes, node);

        if (Option::is_some(&queue.tail)) {
            let tail_idx = Option::borrow(&queue.tail);
            vector::borrow_mut(&mut queue.nodes, *tail_idx).next = Option::some(idx);
        } else {
            queue.head = Option::some(idx);
        };

        queue.tail = Option::some(idx);
    }

    public fun dequeue<T has copy+drop>(queue: &mut Queue<T>): Option<T> {
        if (Option::is_none(&queue.head)) {
            return Option::none();
        };

        let head_idx = *Option::borrow(&queue.head);
        let node_ref = vector::borrow(&queue.nodes, head_idx);
        let val = copy node_ref.value;
        let next = copy node_ref.next;
        queue.head = next;

        if (Option::is_none(&queue.head)) {
            queue.tail = Option::none();
        };
        Option::some(val)
    }

    // 5. Multiple mutable borrows updates to a local variable
    public fun mut_var_updates(): u64 {
        let x = 1u64;
        // first mutable borrow and update
        let r1 = &mut x; 
        *r1 = 10u64;

        // re-borrow mutably after first borrow goes out of scope
        let r2 = &mut x; 
        *r2 = *r2 + 20u64;

        x
    }

    // 4. Handling special types - Unit and error like Abort
    public fun error_handling_example(should_abort: bool): bool {
        if (should_abort) {
            abort 42;
        };
        // Unit type is ()
        ()
        true
    }
}

//# run 0xCAFE::Queue::mut_var_updates


//# run 0xCAFE::Queue::error_handling_example --args false


//# run 0xCAFE::Queue::error_handling_example --args true



//# run 
script {
    use 0xCAFE::Queue;

    fun main() {
        let q = Queue::new<u8>();

        // 1. Enqueue multiple items
        Queue::enqueue(&mut q, 10u8);
        Queue::enqueue(&mut q, 20u8);
        Queue::enqueue(&mut q, 30u8);

        // 1. Dequeue in FIFO order (no assert needed)
        let o1 = Queue::dequeue(&mut q);
        let o2 = Queue::dequeue(&mut q);
        let o3 = Queue::dequeue(&mut q);
        let o4 = Queue::dequeue(&mut q);

        // options can be matched if needed, here we just ignore return values
        let _ = o1;
        let _ = o2;
        let _ = o3;
        let _ = o4;
    }
}


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// fe4621ae0d61f411fef5c1f6ecd21071: Recognize and handle special types like Unit or UnresolvedError for error management.
// 18dbad6c773553c671ab63b2482bfced: Test that multiple mutable borrows and updates to a local variable within the same function work correctly and return the expected result.
