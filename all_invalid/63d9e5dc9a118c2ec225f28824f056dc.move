
//# publish
module 0xCAFE::MixedUse {
    use std::vector;
    use std::vector::{empty, push_back};
    use std::signer;
    
    // A simple function to create a vector of u8 from 1 to n
    public fun create_vector(n: u8): vector<u8> {
        let v = empty<u8>();
        let v = v;
        let i = 1;
        while (i <= n) {
            push_back(&mut v, i);
            i = i + 1;
        };
        v
    }

    // Iterate using foreach and sum all elements
    public fun foreach_sum(v: vector<u8>): u64 {
        let sum = 0u64;
        vector::foreach<u8>(&v, |item: &u8| {
            sum = sum + (*item as u64);
        });
        sum
    }

    // Unpack a tuple with unused variables bound to _
    public fun unpack_and_ignore(a: (u8, u8, u8)): u8 {
        let (_x, y, _z) = a;
        y
    }
}


//# run 0xCAFE::MixedUse::create_vector --args 5u8


//# run 0xCAFE::MixedUse::foreach_sum --args vector[1u8, 2u8, 3u8, 4u8, 5u8]


//# run 0xCAFE::MixedUse::unpack_and_ignore --args (10u8, 20u8, 30u8)


// Featurres:
// 263616b9c4308e5aaf87b451b8c5f099: Combine importing a module and specific members in 'use' statements.
// 6429218e3e29ce1b963e2bcaa3f3a253: Test that the `foreach` function correctly iterates over a vector and computes the sum of its elements.
// e72a272d426fefa1d35ea88d03eb3386: Use variable names to unbind variables during unpacking operations.
