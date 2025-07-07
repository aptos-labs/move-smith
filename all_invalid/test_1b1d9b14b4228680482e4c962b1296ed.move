//# publish
module 0xA1B2::task_queue {
    use std::vector;

    struct TaskQueue<T> has key, drop {
        tasks: vector<T>,
    }

    public fun create<T>(): TaskQueue<T> {
        TaskQueue { tasks: vector::empty() }
    }

    public fun enqueue<T>(queue: &mut TaskQueue<T>, task: T) {
        vector::push_back(&mut queue.tasks, task);
    }

    public fun dequeue<T>(queue: &mut TaskQueue<T>): T {
        let task = vector::remove(&mut queue.tasks, 0);
        task
    }

    // Function to test enqueuing multiple tasks and then dequeuing them in FIFO order
    public fun test_task_order() {
        let queue = create<u64>();
        enqueue(&mut queue, 101);
        enqueue(&mut queue, 102);
        enqueue(&mut queue, 103);
        assert!(dequeue(&mut queue) == 101, 1);
        enqueue(&mut queue, 104);
        assert!(dequeue(&mut queue) == 102, 2);
        assert!(dequeue(&mut queue) == 103, 3);
        assert!(dequeue(&mut queue) == 104, 4);
    }

    // Runner function to invoke the test
    public fun run_test() {
        test_task_order();
    }
}

//# run 0xA1B2::task_queue::run_test

// Additional test to verify interleaved enqueue/dequeue operations
//# publish
module 0xA1B2::interleaved_test {
    use 0xA1B2::task_queue;

    public fun perform_interleaved_operations() {
        let queue = task_queue::create<u8>();
        task_queue::enqueue(&mut queue, 10);
        task_queue::enqueue(&mut queue, 20);
        assert!(task_queue::dequeue(&mut queue) == 10, 1);
        task_queue::enqueue(&mut queue, 30);
        assert!(task_queue::dequeue(&mut queue) == 20, 2);
        assert!(task_queue::dequeue(&mut queue) == 30, 3);
    }

    // Runner to test the interleaved behavior
    public fun run_interleaved() {
        perform_interleaved_operations();
    }
}

//# run 0xA1B2::interleaved_test::run_interleaved

// Additional interaction with the map-like transformation and demonstrating correctness
//# publish
module 0xA1B2::map_transform {
    use std::vector;

    const NUMBERS: vector<u64> = vector[1, 2, 3];

    public entry fun transform_vectors() {
        // Map over NUMBERS adding 10 to each element
        let mapped: vector<u64> = vector::map(&NUMBERS, |n| n + 10);
        // Map over the same vector multiplying each element by 2
        let doubled: vector<u64> = vector::map(&mapped, |n| n * 2);
        // No assertions, just transformations
    }
}

//# run 0xA1B2::map_transform::transform_vectors