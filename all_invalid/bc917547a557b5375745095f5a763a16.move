//# publish
module 0xCAFE::BlockSpecFilter {

    use std::signer;
    use std::vector;
    use std::move_to;
    use std::borrow_global;

    struct Sample has copy, drop, store, key {
        val1: u64,
        val2: u64,
    }

    public fun write_sequences(s: signer) {
        {
            let x = 1u64;
            let y = 2u64;
            let z = x + y;
            let _ = z;
        }
        {
            let mut sum = 0u64;
            let mut i = 0u64;
            while (i < 5) {
                sum = sum + i;
                i = i + 1;
            }
            let _ = sum;
        }
        {
            let arr = vector[10u64,20u64,30u64];
            for elem in &arr {
                let _ = *elem;
            }
        }
    }

    spec module {
        // Removed or commented invalid spec condition referencing unbound `val`
        // condition val > 0;
    }

    public fun create_sample(s: signer, v1: u64, v2: u64) {
        let obj = Sample { val1: v1, val2: v2 };
        move_to<Sample>(&s, obj);
    }

    public fun get_val1(s: signer): u64 acquires Sample {
        let sample_ref = borrow_global<Sample>(signer::address_of(&s));
        sample_ref.val1
    }

    spec get_val1 {
        ensures result > 0;
    }

    public fun filter_members() {
        // Placeholder function
    }
}

//# run 0xCAFE::BlockSpecFilter::write_sequences --signers 0xBEEF

//# run 0xCAFE::BlockSpecFilter::create_sample --signers 0xBEEF --args 42u64 100u64

//# run 0xCAFE::BlockSpecFilter::get_val1 --signers 0xBEEF

//# run 0xCAFE::BlockSpecFilter::filter_members