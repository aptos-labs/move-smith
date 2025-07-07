//# publish
module 0xCAFE::VectorWithTypeParam {
    use std::vector;

    #[test_only]
    public fun create_vector_u64(): vector<u64> {
        vector::empty<u64>()
    }

    #[test_only]
    public fun create_vector_address(): vector<address> {
        vector::empty<address>()
    }

    #[test_only]
    public fun add_elements_u64(v: &mut vector<u64>) {
        vector::push_back(v, 10u64);
        vector::push_back(v, 20u64);
    }

    #[test_only]
    public fun add_elements_address(v: &mut vector<address>) {
        vector::push_back(v, @0xCAFE);
        vector::push_back(v, @0xBEEF);
    }

    #[test_only]
    public fun runner() {
        let mut v_u64 = create_vector_u64();
        add_elements_u64(&mut v_u64);

        let mut v_addr = create_vector_address();
        add_elements_address(&mut v_addr);
    }
}
//# run 0xCAFE::VectorWithTypeParam::runner

//# publish
module 0xCAFE::AttributesExample {
    #[test_only]
    #[inline(always)]
    public fun always_inline_function(): u8 {
        42u8
    }

    #[test_only]
    #[deprecated(since = "1.0.0", reason = "Use always_inline_function instead")]
    public fun deprecated_function(): u8 {
        0u8
    }

    #[test_only]
    public fun runner() {
        let _ = always_inline_function();
        let _ = deprecated_function();
    }
}
//# run 0xCAFE::AttributesExample::runner

//# publish
module 0xCAFE::SpecExtractor {
    #[spec(public)]
    spec module {
        fun example_spec(): bool {
            true
        }
    }

    #[test_only]
    public fun runner() {
        // Spec is just declared here, no runtime logic needed.
    }
}
//# run 0xCAFE::SpecExtractor::runner

//# run
script {
    fun main() {
        // Intentionally left blank - test relies on module runners
    }
}

// Featurres:
// 1df1c75b7c273f1fbf3eb764932c6eec: Use type parameters properly within vector types.
// 10163e7c3b2f0cf1fc228134b410143b: Annotate code with attributes using brackets preceded by a '#' sign
// 13df41857e7eace81575b0e86c8533d2: Extract and display the public specification of a Move module for documentation or review.
