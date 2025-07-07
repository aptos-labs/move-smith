//# publish
module 0xABCD::Counter {
    struct Counter has store {
        count: u64,
        limit: u64
    }

    public fun new(limit: u64): Counter {
        Counter { count: 0, limit }
    }

    public fun get_count(c: &Counter): u64 {
        c.count
    }

    public fun increment(c: &mut Counter): bool {
        if (c.count < c.limit) {
            c.count = c.count + 1;
            true
        } else {
            false
        }
    }
}

//# run
script {
use 0xABCD::Counter;
fun main() {
    let c = Counter::new(5);

    // Verify initial count
    assert!(Counter::get_count(&c) == 0, 70004);

    let mut i = 0;
    // Loop to increment counter up to limit
    while (i < Counter::get_count(&c)) {
        // This block won't run since count starts at 0,
        // but the structure allows testing mutable updates
        assert!(Counter::increment(&mut c), 70005);
        i = i + 1;
    }

    // Now increment until limit is reached
    let mut total_increments = 0;
    while (Counter::get_count(&c) < 5) {
        let success = Counter::increment(&mut c);
        if (success) {
            total_increments = total_increments + 1;
        }
    }

    // After loop, count should be at limit
    assert!(Counter::get_count(&c) == 5, 70006);
    // Ensure total increments counted correctly
    assert!(total_increments == 5, 70007);
}
}