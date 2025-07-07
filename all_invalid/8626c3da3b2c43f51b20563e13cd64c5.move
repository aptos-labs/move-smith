
//# publish
module 0xCAFE::NamedAddressExample {
    // Named address: 0xCAFE
    use std::vector;

    struct Counter has store {
        count: u64,
    }

    public fun create_counter(): Counter {
        Counter { count: 0 }
    }

    public fun increment(counter: &mut Counter) {
        let i = 0u64;
        let max = 5u64;

        spec {
            let c = counter.count;
            invariant i <= max;
            invariant counter.count <= c + max;
        }

        while (i < max) {
            counter.count = counter.count + 1;
            i = i + 1;
        };
    }

    public fun get_count(counter: &Counter): u64 {
        counter.count
    }
}



//# run
script {
    use 0xCAFE::NamedAddressExample;

    fun main() {
        // create counter resource (non-key)
        let c = NamedAddressExample::create_counter();
        NamedAddressExample::increment(&mut c);
        let _count = NamedAddressExample::get_count(&c);
    }
}
