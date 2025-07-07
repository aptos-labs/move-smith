//# publish
module 0xCAFE::FieldParser {
    use std::string;
    use std::vector;
    use std::error;
    use std::option;
    use std::ascii;

    struct FieldId has copy, drop, store {
        id: vector<u8>,
    }

    /// Parses a field identifier from a string slice.
    /// Returns a FieldId with the bytes of the identifier.
    public fun parse_field_id(field_name: &string::String): FieldId {
        let bytes = string::utf8_bytes(field_name);
        // For demonstration just return the bytes as is.
        FieldId { id: bytes }
    }

    /// Simple "runner" function that calls parse_field_id with some hardcoded value.
    public fun runner() {
        let field_name = string::utf8(b"my_field");
        let _field_id = parse_field_id(&field_name);
    }

    /// Spec block including an invariant to validate the field id length >= 0 (always true)
    spec module {
        invariant forall id: FieldId {
            id.id.length() >= 0
        }
    }
}
//# run 0xCAFE::FieldParser::runner

//# publish
module 0xCAFE::LoopInvariant {
    /// Function that counts from 0 to n using a loop that has an invariant.
    public fun count_to_n(n: u64): u64 {
        let mut i = 0u64;
        let mut sum = 0u64;

        while (i < n) {
            // loop invariant ensures i <= n
            invariant i <= n;
            sum = sum + i;
            i = i + 1;
        }
        sum
    }

    public fun runner() {
        let _ = count_to_n(10);
    }

    spec module {
        invariant true // trivial invariant at module level
    }

    spec fun count_to_n(n: u64) {
        let mut i: u64;
        // loop invariant
        invariant i <= n;
    }
}
//# run 0xCAFE::LoopInvariant::runner

//# run
script {
    use std::string;
    use 0xCAFE::FieldParser;

    fun main() {
        // Parse a field identifier from script
        let field_name = string::utf8(b"transaction_field");
        let _field_id = FieldParser::parse_field_id(&field_name);
    }
}

// Featurres:
// adcc48dd1c169a1ada209210842c1dc8: Declare Move scripts directly in the source.
// 08082b21b4090d159c6641a7a7311704: Include only `invariant` conditions inside `spec` blocks to ensure proper validation of loop invariants.
// f5014c7009be5aab9d4537d12f9d7e37: Parse a move field identifier from source code
