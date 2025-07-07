//# publish
module 0xCAFE::LoopPhantomTest {
    use std::marker;

    phantom struct PhantomType<T> {}

    struct Counter<phantom T> has copy, drop, store {
        count: u64,
        _phantom: PhantomType<T>,
    }

    public fun new_counter<T>(): Counter<T> {
        Counter {
            count: 0,
            _phantom: PhantomType {},
        }
    }

    public fun inc_counter<T>(c: &mut Counter<T>) {
        c.count = c.count + 1;
    }

    public fun get_count<T>(c: &Counter<T>): u64 {
        c.count
    }

    // Runner function that uses a labeled infinite loop to count to 5 and returns the count
    public fun run_loop_test(): u64 {
        let mut counter = new_counter<u8>();
        'outer: loop {
            inc_counter(&mut counter);
            if (counter.count == 5) {
                break 'outer;
            }
        }
        get_count(&counter)
    }
}

//# run 0xCAFE::LoopPhantomTest::run_loop_test


//# run
script {
    // Use an infinite loop with a label and return from inside the loop
    let mut i: u8 = 0;

    'infinite_loop: loop {
        i = i + 1;
        if (i == 3) {
            // return from script with value 42
            return;
        }
    };
}

// Featurres:
// da995ca930eb096498e922040b7bab4c: Use loop expressions with optional labels for infinite loops.
// 47683053c10f197cf3a788b32aeb628c: Mark struct type parameters as phantom using the 'phantom' keyword in struct definitions
// 3785cb86f5fee2e959911bb4f800ad4b: Test that the `loop` expression can be used with a `return` statement in a script.
