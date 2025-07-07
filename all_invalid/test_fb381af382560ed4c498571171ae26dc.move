//# publish
module 0xabc::counter_module {
    struct Counter has drop {
        count: u64
    }

    public fun create(): Counter {
        Counter { count: 0 }
    }

    public fun increment(c: &mut Counter): u64 {
        c.count = c.count + 1;
        c.count
    }

    public fun get(c: &Counter): u64 {
        c.count
    }
}

//# run
script {
use 0xabc::counter_module;

fun main() {
    let counter = counter_module::create();

    // Increment the counter several times and verify the count
    let mut total = 0;
    let mut i = 0;
    while (i < 5) {
        let new_count = counter_module::increment(&mut counter);
        total = total + new_count;
        i = i + 1;
    }

    // After 5 increments, the count should be 5
    assert!(counter_module::get(&counter) == 5, 70004);
    // The total sum should be 1+2+3+4+5 = 15
    assert!(total == 15, 70005);
}
}

//# run 0xabc::counter_module::main

//# publish
module 0xabc::enum_nested {
    enum Inner {
        X(u64),
        Y,
    } has drop;

    enum Outer {
        First(Inner),
        Second,
    } has drop;

    fun handle_variant(x: Outer) {
        match (x) {
            Outer::First(Inner::X(_)) => (),
            Outer::First(Inner::Y) => (),
            Outer::Second => (),
        }
    }

    fun test_enum_handling() {
        let a = Outer::First(Inner::X(123));
        handle_variant(a);

        let b = Outer::First(Inner::Y);
        handle_variant(b);

        let c = Outer::Second;
        handle_variant(c);
    }
    public fun main() {
        test_enum_handling();
    }
}

//# run 0xabc::enum_nested::main

//# publish
module 0xabc::mutable_resource_loop {
    struct CountDown has drop {
        value: u64
    }

    public fun new(initial: u64): CountDown {
        CountDown { value: initial }
    }

    public fun get_value(c: &CountDown): u64 {
        c.value
    }

    public fun decrement(c: &mut CountDown): u64 {
        c.value = c.value - 2;
        c.value
    }
}

//# run
script {
use 0xabc::mutable_resource_loop;

fun main() {
    let mut rd = mutable_resource_loop::new(10);
    let mut sum = 0;
    let mut i = 0;

    // Loop until resource value drops below 0 (simulate with condition)
    while (mutable_resource_loop::get_value(&rd) > 0 && i < 10) {
        let val = mutable_resource_loop::decrement(&mut rd);
        sum = sum + val;
        i = i + 1;
    }

    // After the loop, the value should be less than or equal to 0 or loop limit hit
    assert!(mutable_resource_loop::get_value(&rd) <= 0, 70006);
    // The sum should reflect the sum of decreasing by 2 each iteration starting from 10
    // For 5 iterations: 8 + 6 + 4 + 2 + 0 = 20, plus last iteration if loop continues
    // But since we take max condition, assert the sum is as expected for that scenario
}
}