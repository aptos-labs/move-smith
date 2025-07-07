
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
    use std::signer;
    use 0xCAFE::NamedAddressExample;

    fun main(s: signer) {
        // create counter resource (non-key) 
        let c = NamedAddressExample::create_counter();
        NamedAddressExample::increment(&mut c);
        let _count = NamedAddressExample::get_count(&c);
    }
}


// Featurres:
// 920f7c949c77e39990902bece833ed42: Refer to named addresses in your Move code, provided that a value is assigned at compile time.
// 4b11123d344e171b852c0c964e14cdb2: Use loop invariants in spec blocks inside Move code to specify properties that should hold true across loop iterations
// c5d6a5f9cde63291ecf21af67224ce85: Use address specifier 'Name' to refer to a named address in your code.
