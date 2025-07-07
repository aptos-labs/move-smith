//# publish
module 0xCAFE::ClosureTest {
    use std::signer;

    // A simple inline function that takes a closure with 1 u8 input and returns u8
    public inline fun call_closure(f: |u8|u8, val: u8): u8 {
        f(val)
    }

    // A non-inline function to pass as closure and test the inline call_closure
    public fun add_one(x: u8): u8 {
        x + 1
    }

    // A runner function that uses call_closure and add_one
    public fun runner(): u8 {
        let closure: |u8|u8 has copy+drop = add_one;
        call_closure(closure, 41u8)
    }

    // A function with an infinite loop to simulate gas exhaustion (will abort eventually)
    public fun infinite_loop(): u8 {
        let mut counter = 0u8;
        loop {
            // infinite loop without break
            counter = counter + 1;
        };
        counter
    }
}

//# run 0xCAFE::ClosureTest::runner

//# run 0xCAFE::ClosureTest::infinite_loop

// Featurres:
// 5088acc417798600c0e061ae3cd83653: Use 'use' declarations to import modules or items into the current scope
// 6c7f57231e4d203ef1b2da0870bd7436: Test that an inline function can accept closures as arguments and correctly invoke them with given parameters.
// 29b8ce4d68d906a6b74257922e28c0a0: Test that the transaction correctly fails and aborts when it runs out of gas due to an infinite loop.
