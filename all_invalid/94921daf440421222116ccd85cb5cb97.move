//# publish
module 0xCAFE::SequenceModule {
    use std::vector;

    //# publish
    #[skip_lint(unused)]
    public fun create_seq(): vector<u64> {
        // Create a sequence (vector) with initial values
        let seq: vector<u64> = vector::empty<u64>();
        // Append some values
        vector::push_back(&mut seq, 10);
        vector::push_back(&mut seq, 20);
        vector::push_back(&mut seq, 30);
        seq
    }

    //# publish
    public fun get_item_at(seq: &vector<u64>, index: u64): u64 {
        // Access item at index with expression
        vector::borrow(seq, (index as usize))
    }

    //# publish
    public fun set_item_at(seq: &mut vector<u64>, index: u64, value: u64) {
        vector::borrow_mut(seq, (index as usize)).write(value);
    }

    //# publish
    public fun sequence_exprs(): vector<u64> {
        let v: vector<u64> = vector::empty<u64>();
        // Use expressions in sequence items
        vector::push_back(&mut v, (1 + 2) as u64);
        vector::push_back(&mut v, (3 * 4) as u64);
        vector::push_back(&mut v, (100 - 50) as u64);
        vector::push_back(&mut v, (128 / 2) as u64);
        v
    }

    // Optional: a runner function if needed (not strictly required here)
    public fun run_all() {
        let seq = create_seq();
        let item0 = get_item_at(&seq, 0);
        let item1 = get_item_at(&seq, 1);
        set_item_at(&mut seq, 0, 2);
        let exprs_seq = sequence_exprs();
    }
}

//# run 0xCAFE::SequenceModule::create_seq --signers 0xDEAD
//# run 0xCAFE::SequenceModule::sequence_exprs --signers 0xDEAD
//# run 0xCAFE::SequenceModule::get_item_at --signers 0xDEAD --args 0u64
//# run 0xCAFE::SequenceModule::set_item_at --signers 0xDEAD --args 0u64 2u64