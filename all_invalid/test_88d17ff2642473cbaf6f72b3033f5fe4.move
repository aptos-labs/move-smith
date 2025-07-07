//# publish
module 0x99::MutableLoopTest {
    struct Counter has store {
        count: u64
    }

    public fun new(): Counter {
        Counter { count: 0 }
    }

    public fun get_count(c: &Counter): u64 {
        c.count
    }

    public fun increment(c: &mut Counter): void {
        c.count = c.count + 2;
    }

    public fun run_loop(): u64 {
        let counter = new();
        let i: u64 = 0;

        // Loop to modify the resource and verify its state
        let mut i_local = i;
        while (i_local < 5) {
            // Modify resource in each iteration
            increment(&mut counter);
            i_local = i_local + 1;
        }
        // After loop, the count should be 2 times 5 = 10
        get_count(&counter)
    }
}

//# run
script {
    use 0x99::MutableLoopTest;

    fun main() {
        let final_count = MutableLoopTest::run_loop();

        // Expected final count is 10 after 5 iterations with increments of 2 each
        assert!(final_count == 10, 70004);
    }
}
