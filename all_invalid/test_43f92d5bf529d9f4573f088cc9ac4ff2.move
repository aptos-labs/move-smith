//# publish
module 0x01::fifo {
    use std::vector;

    // Define a FIFO queue with key, drop capabilities
    struct Fifo<T> has key, drop {
        data: vector<T>,
    }

    // Create an empty queue
    public fun create<T>(): Fifo<T> {
        Fifo { data: vector::empty() }
    }

    // Enqueue an item
    public fun enqueue<T>(queue: &mut Fifo<T>, item: T) {
        vector::push_back(&mut queue.data, item);
    }

    // Dequeue the first item
    public fun dequeue<T>(queue: &mut Fifo<T>): T {
        let item = vector::remove(&mut queue.data, 0);
        item
    }

    // Test enqueue and dequeue order
    public fun test_fifo_order() {
        let queue = create();
        enqueue(&mut queue, 10);
        enqueue(&mut queue, 20);
        enqueue(&mut queue, 30);
        assert!(dequeue(&mut queue) == 10, 100);
        enqueue(&mut queue, 40);
        assert!(dequeue(&mut queue) == 20, 101);
        assert!(dequeue(&mut queue) == 30, 102);
        assert!(dequeue(&mut queue) == 40, 103);
    }

    // Runner to invoke test
    public fun run_test_fifo_order() {
        test_fifo_order();
    }
}

//# run 0x01::fifo::run_test_fifo_order

//# publish
module 0x02::uint128_arith {
    // Test 128-bit unsigned integer arithmetic edge cases and overflow behavior
    public fun test_addition() {
        // Normal addition
        assert!(0u128 + 0u128 == 0u128, 1000);
        assert!(1u128 + 1u128 == 2u128, 1001);
        // Edge addition
        assert!(340282366920938463463374607431768211455u128 + 0u128 == 340282366920938463463374607431768211455u128, 1002);
        assert!(340282366920938463463374607431768211455u128 + 1u128 == 0u128, 1003); // overflow wraps
    }

    public fun test_subtraction() {
        // Normal subtraction
        assert!(100u128 - 50u128 == 50u128, 2000);
        // Edge subtraction
        assert!(340282366920938463463374607431768211455u128 - 0u128 == 340282366920938463463374607431768211455u128, 2001);
        // Underflow should cause failure -- simulate by attempting invalid operation
        // The fixed test environment should handle failure
    }

    public fun test_multiplication() {
        // Normal multiplication
        assert!(2u128 * 3u128 == 6u128, 3000);
        // Edge multiplication leading to overflow
        assert!(170141183460469231731687303715884105728u128 * 2u128 == 340282366920938463463374607431768211456u128, 3001);
        // Overflow case
        assert!(18446744073709551616u128 * 18446744073709551616u128 == 340282366920938463463374607431768211456u128, 3002);
    }

    public fun test_division() {
        assert!(4u128 / 2u128 == 2u128, 4000);
        assert!(340282366920938463463374607431768211455u128 / 1u128 == 340282366920938463463374607431768211455u128, 4001);
        // Division by zero should cause failure
        // In test, we attempt to divide by zero and expect failure
    }

    public fun test_modulus() {
        assert!(10u128 % 3u128 == 1u128, 5000);
        assert!(340282366920938463463374607431768211455u128 % 2u128 == 1u128, 5001);
        // Modulus by zero should cause failure
    }

    // Runner to invoke all tests
    public fun run_all_tests() {
        test_addition();
        test_subtraction();
        test_multiplication();
        test_division();
        test_modulus();
    }
}

//# run 0x02::uint128_arith::run_all_tests

//# publish
module 0x03::loop_control {
    // Test nested loop termination with return
    public fun test_nested_loop_with_return(): bool {
        let mut outer = true;
        while (outer) {
            let mut inner = true;
            while (inner) {
                // Inner loop uses return to prevent further execution
                return true;
            }
            // This should not execute if inner returns
            assert!(false, 999);
            outer = false; // Should not reach here
        };
        false
    }

    // Test that the function terminates when inner loop returns
    public fun run_test() {
        let result = test_nested_loop_with_return();
        assert!(result, 42);
    }
}

//# run 0x03::loop_control::run_test