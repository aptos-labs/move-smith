
//# publish
module 0xCAFE::QueueModule {
    use std::vector;

    // Added drop ability so values of type T can be dropped safely
    struct Queue<T> has store, drop {
        items: vector<T>
    }

    public fun new<T>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    public fun enqueue<T>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    public fun dequeue<T>(q: &mut Queue<T>): T {
        // Do not copy content to local by dereference, borrow and consume
        // instead consume the value with vector::remove which returns the item removed
        // This way we avoid copying or dropping T implicitly.
        vector::remove(&mut q.items, 0)
    }

    public fun len<T>(q: &Queue<T>): u64 {
        vector::length(&q.items)
    }

    public fun test_fifo() {
        let q = new<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);
        let a = dequeue(&mut q); // should be 10u8
        let b = dequeue(&mut q); // should be 20u8
        let c = dequeue(&mut q); // should be 30u8

        // Instead of assigning a tuple to single _, assign each one separately:
        let _a = a;
        let _b = b;
        let _c = c;
    }

    public fun lambda_test(): u8 {
        let adder: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let result = adder(5u8, 7u8);
        result
    }
}



//# run 0xCAFE::QueueModule::test_fifo


//# run 0xCAFE::QueueModule::lambda_test




//# publish
module 0xCAFE::CallInlineModule {
    //
    // Removed use 0xCAFE::MyModule; because it's invalid (no such module).
    // Since the task is the fixing of errors, and the function MyModule::f2 is not defined,
    // we cannot call it. We must remove or replace this code.
    //
    // For completeness, let's instead implement f2 here (example)
    //

    public inline fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }

    public inline fun call_f2_plus_one(a: u16): u16 {
        let (x, y) = f2(a);
        x + y + 1
    }

    public fun call_f2_plus_one_runner(): u16 {
        call_f2_plus_one(5u16)
    }
}



//# run 0xCAFE::CallInlineModule::call_f2_plus_one_runner
