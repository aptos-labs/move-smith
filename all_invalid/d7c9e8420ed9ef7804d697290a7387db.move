
//# publish
module 0xCAFE::DecreasesUsesExample {
    use std::signer;
    use std::move;

    struct Counter has store, key {
        count: u64,
    }

    public fun init_counter(s: signer) {
        let counter = Counter { count: 10 };
        move_to<Counter>(&s, counter);
    }

    public fun decrement(s: signer) acquires Counter {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(&s));
        let n = counter_ref.count;

        // We use a while loop with a decreases expression on n for termination
        while (n > 0) decreases (n) {
            n = n - 1;
        };

        counter_ref.count = n;
    }

    public fun get_count(s: signer): u64 acquires Counter {
        let counter_ref: &Counter = borrow_global<Counter>(signer::address_of(&s));
        counter_ref.count
    }

    // Runner function to init and decrement counter without args
    public fun runner(s: signer) acquires Counter {
        init_counter(s);
        decrement(s);
    }
}




//# publish
module 0xCAFE::AliasAndScript {
    use 0xCAFE::DecreasesUsesExample;
    use 0xCAFE::DecreasesUsesExample as AliasExample;

    // A script function that calls the aliased module function
    public fun use_alias(s: signer) acquires DecreasesUsesExample::Counter {
        AliasExample::decrement(s);
    }
}




//# script
//# run
script {
    use std::signer;
    use 0xCAFE::DecreasesUsesExample;
    use 0xCAFE::AliasAndScript;

    fun main() {
        let addr = @0xF00D;
        // Pass signer reference with dummy signer create approach in test context
        // Init counter at addr F00D for fresh test
        // Normally signer comes from the framework test environment
        // Here we mimic calls assuming signer is passed

        // This assumes the test environment allows signer to addr F00D,
        // for demonstration sake we just call functions with signer of addr

        DecreasesUsesExample::init_counter(signer::spec_signer_of(addr));
        DecreasesUsesExample::decrement(signer::spec_signer_of(addr));
        let count = DecreasesUsesExample::get_count(signer::spec_signer_of(addr));

        AliasAndScript::use_alias(signer::spec_signer_of(addr));
        let final_count = DecreasesUsesExample::get_count(signer::spec_signer_of(addr));
    }
}
