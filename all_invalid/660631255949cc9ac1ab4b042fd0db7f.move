//# publish
module 0x1::TestSequences {
    use std::vector;

    /// Represents a statement node, for testing sequences of statements.
    struct Statement has copy, drop, store {
        value: u64,
    }

    /// A sequence of statements
    struct StatementSequence has store {
        stmts: vector<Statement>,
    }

    /// Create a new empty sequence.
    public fun new_sequence(): StatementSequence {
        StatementSequence { stmts: vector::empty<Statement>() }
    }

    /// Append a statement to the sequence.
    public fun append(seq: &mut StatementSequence, stmt: Statement) {
        vector::push_back(&mut seq.stmts, stmt);
    }

    /// Returns the last statement in the sequence (if any).
    public fun last_statement(seq: &StatementSequence): Option<Statement> {
        let len = vector::length(&seq.stmts);
        if (len == 0) {
            Option::none<Statement>()
        } else {
            Option::some(vector::borrow(&seq.stmts, len - 1))
        }
    }

    /// Build a sample sequence of 3 statements and return the sequence.
    public fun build_sample_sequence(): StatementSequence {
        let mut seq = new_sequence();
        append(&mut seq, Statement { value: 10u64 });
        append(&mut seq, Statement { value: 20u64 });
        append(&mut seq, Statement { value: 30u64 });
        seq
    }

    /// A runner function to test sequences.
    public fun runner() {
        let seq = build_sample_sequence();
        let last = last_statement(&seq);
        // last should be Some with value 30, but we skip assertion as per instruction.
        // Just branch to consume Option (test pattern matching)
        if (Option::is_some(&last)) {
            let stmt = Option::borrow(&last);
            let _x = stmt.value;
        }
    }
}
//# run 0x1::TestSequences::runner


//# publish
module 0x1::TestPeekToken {
    /// Returns true if the token `token` equals the `current_token`. Does not advance.
    public fun peek_token(current_token: u8, token: u8): bool {
        current_token == token
        // no advance, just comparison
    }

    /// A runner function: test various tokens.
    public fun runner() {
        assert!(peek_token(5u8, 5u8), 0);
        assert!(!peek_token(3u8, 7u8), 1);
    }
}
//# run 0x1::TestPeekToken::runner


//# publish
module 0x1::RemoveDuplicates {
    use std::vector;
    use std::option;

    /// Remove duplicate attributes represented as u64 values from the vector.
    /// The input is sorted or unsorted.
    public fun remove_duplicates(attrs: vector<u64>): vector<u64> {
        let mut uniques = vector::empty<u64>();
        let len = vector::length(&attrs);
        let mut i = 0;
        while (i < len) {
            let val = *vector::borrow(&attrs, i);
            if (!vector::contains(&uniques, &val)) {
                vector::push_back(&mut uniques, val);
            };
            i = i + 1;
        }
        uniques
    }

    /// Runner to test remove_duplicates.
    public fun runner() {
        let attrs = vector::from_bytes<u64, 5>(
            vector::serialize(&[1u64, 2u64, 2u64, 3u64, 1u64])
        );
        // Above is just conceptual; Move doesn't support vector::from_bytes for u64,
        // so manual creation below instead:
        // let attrs = vector::empty<u64>();
        // vector::push_back(&mut attrs, 1);
        // vector::push_back(&mut attrs, 2);
        // vector::push_back(&mut attrs, 2);
        // vector::push_back(&mut attrs, 3);
        // vector::push_back(&mut attrs, 1);
        // We'll just do it manually now.
    }

    /// Manual runner with pushing vectors.
    public fun runner() {
        let mut attrs = vector::empty<u64>();
        vector::push_back(&mut attrs, 1);
        vector::push_back(&mut attrs, 2);
        vector::push_back(&mut attrs, 2);
        vector::push_back(&mut attrs, 3);
        vector::push_back(&mut attrs, 1);
        let uniques = remove_duplicates(attrs);
        // Consume uniques by reading length.
        let _l = vector::length(&uniques);
    }
}
//# run 0x1::RemoveDuplicates::runner


//# run
script {
    use 0x1::TestSequences;
    use 0x1::TestPeekToken;
    use 0x1::RemoveDuplicates;

    fun main() {
        // Run the runner functions directly to test.
        TestSequences::runner();
        TestPeekToken::runner();
        RemoveDuplicates::runner();
    }
}