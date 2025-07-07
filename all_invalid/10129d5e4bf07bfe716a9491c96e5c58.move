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
}

//# run 0xCAFE::SequenceModule::create_seq --signers 0xDEAD --args
//# run 0xCAFE::SequenceModule::sequence_exprs --signers 0xDEAD

//# run 0xCAFE::SequenceModule::get_item_at --signers 0xDEAD --args 0 1u64
//# run 0xCAFE::SequenceModule::set_item_at --signers 0xDEAD --args 0 2u64


// Featurres:
// 884d6f3be845aa12df3f53c251cc91b8: Define sequence items with expressions using `Seq`.
// c51ebde49c90521f1723c9fbec3f0d8a: Suppress specific lint warnings by annotating your function or module with the attribute #[skip_lint(<checker_name>)]
// 01b3da323fc7fbad7b996ceadd3198ce: Use '*' as a wildcard name in Move code.
