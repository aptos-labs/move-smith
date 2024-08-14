//# publish
module 0xCAFE::FuzzStore {
    use std::bcs;
    use std::hash;
    use std::signer;
    use std::vector;

    struct AccumulatedHash has drop, copy, store, key {
        acc: vector<u8>
    }

    fun init_accumulated_hash(s: signer) {
        let sref = &s;
        internal_init_accumulated_hash(sref);
    }

    fun internal_init_accumulated_hash(sref: &signer) {
        let acc = AccumulatedHash { acc: vector::empty() };
        move_to<AccumulatedHash>(sref, acc);
    }

    public fun record_value<T>(sref: &signer, x: &T) acquires AccumulatedHash {
        let addr = signer::address_of(sref);
        let acc = borrow_global_mut<AccumulatedHash>(signer::address_of(sref));
        vector::append(&mut acc.acc, bcs::to_bytes(x));
        acc.acc = hash::sha3_256(acc.acc);
    }

    public fun get_current_hash(s: signer): vector<u8> acquires AccumulatedHash {
        let sref = &s;
        let acc = borrow_global<AccumulatedHash>(signer::address_of(sref));
        acc.acc
    }
}

//# run 0xCAFE::FuzzStore::init_accumulated_hash --signers 0xBEEF 
