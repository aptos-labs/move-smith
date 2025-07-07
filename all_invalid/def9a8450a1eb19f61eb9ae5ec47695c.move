// Using 0xCAFE as the test address

//# publish
module 0xCAFE::SpecInlineMultiRet {
    use std::error;
    use std::signer;

    // A resource struct to store a counter for demo
    struct Counter has key, store {
        value: u64,
    }

    // inline function returning multiple values: the new counter and a bool indicating if it passed some threshold
    public inline fun increment_and_check(counter: &mut Counter, increment: u64): (u64, bool) {
        let new_value = counter.value + increment;
        counter.value = new_value;
        let passed = new_value > 10;
        (new_value, passed)
    }

    // Normal (non-inline) function, calls the inline function and returns the tuple unchanged
    public fun normal_increment(counter: &mut Counter, increment: u64): (u64, bool) {
        increment_and_check(counter, increment)
    }

    // Function that aborts if counter.value is more than 20
    public fun abort_if_too_big(counter: &Counter) acquires Counter {
        spec {
            aborts_if counter.value > 20;
            ensures counter.value <= 20;
        }
        if (counter.value > 20) {
            abort error::invalid_state(42);
        }
    }

    // Initialize a counter resource under the signer
    public fun init_counter(account: &signer) {
        let counter = Counter { value: 0 };
        move_to(account, counter);
    }

    // Runner function with no arguments calls multiple functions to demonstrate inline and multi-return handling  
    public fun runner(account: &signer) {
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(account));
        // Call inline function directly
        let (val1, passed1) = increment_and_check(counter_ref, 5);
        // call normal function wrapping inline function
        let (val2, passed2) = normal_increment(counter_ref, 7);

        // Call abort-if function - only aborts if value > 20 (which should be true here)
        abort_if_too_big(counter_ref);
    }
}
//# run 0xCAFE::SpecInlineMultiRet::runner --signers 0xCAFE

// Featurres:
// 975070a454f8d998224d0e35ed317a92: Write specification conditions (e.g., requires, ensures, aborts_if) in spec blocks to annotate expected program behavior.
// 39a5276d71bb4576631a14e3c7dab09f: Support functions with multiple return values by generating appropriate result temporaries and labels.
// 11a4d1fe9892131da3fe1e15c5bf28ca: Write code that calls inline functions and benefit from having those callees' bodies inlined into the caller.
