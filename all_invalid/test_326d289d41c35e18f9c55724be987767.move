//# publish
module 0xABC::Counter {
    struct Counter has copy, drop {
        count: u64
    }

    public fun new(): Counter {
        Counter { count: 0 }
    }

    public fun get(c: &Counter): u64 {
        c.count
    }

    public fun increment(c: &mut Counter): u64 {
        c.count = c.count + 1;
        c.count
    }
}

//# run
script {
use 0xABC::Counter;

fun main() {
    let counter = Counter::new();

    // Verify initial value is 0
    assert!(Counter::get(&counter) == 0, 70001);

    // Loop to increment counter multiple times
    let mut i = 0;
    while (i < 5) {
        let current = Counter::increment(&mut counter);
        // Ensure each increment corresponds to the loop iteration plus one
        assert!(current == i + 1, 70002);
        i = i + 1;
    }

    // Final check
    assert!(Counter::get(&counter) == 5, 70003);
}
}
