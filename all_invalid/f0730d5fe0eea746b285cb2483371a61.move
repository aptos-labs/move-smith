// This transactional test exercises Move compiler and VM features including succeeds_if.
// Address used: 0xCAFE

//# publish
module 0xCAFE::PatternMatchingHarness {
    use std::vector;

    // A struct with copy and drop abilities for easy testing
    struct SwapPair has copy, drop, store {
        a: u64,
        b: u64,
    }

    // A function that swaps 'a' and 'b' using pattern matching with field renaming
    public fun swap_values(pair: SwapPair): (u64, u64) {
        let SwapPair { a: original_a, b: original_b } = pair;
        // swap and return (b, a)
        (original_b, original_a)
    }

    // This succeed_if function always succeeds - just for testing transaction success criteria declaration
    public fun dummy_succeed(): bool {
        succeeds_if(true, 42);
        true
    }

    // Runner function to execute the swap_values on a sample and return the tuple
    public fun runner(): (u64, u64) {
        let p = SwapPair { a: 1, b: 2 };
        swap_values(p)
    }
}
//# run 0xCAFE::PatternMatchingHarness::dummy_succeed --signers 0xCAFE
//# run 0xCAFE::PatternMatchingHarness::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::PatternMatchingHarness;

    fun main() {
        // Test byte and hex strings usage, no asserts needed
        let byte_str = b"Hello, Aptos!\nTesting bytes.";
        let hex_str = x"DEADBEEF";

        // Call dummy_succeed for succeeds_if testing
        let _success = PatternMatchingHarness::dummy_succeed();

        // Call runner to perform pattern matching and swap test
        let (swapped_b, swapped_a) = PatternMatchingHarness::runner();

        // The following variables exist to ensure full usage of features
        // suppressed compiler warnings for unused variables implicitly

        // Note: no assertion needed, just execution and compiling VM coverage
        let _ = byte_str;
        let _ = hex_str;
        let _ = swapped_a;
        let _ = swapped_b;
    }
}

// Featurres:
// 7c3681c4f4c4a14d24c384d7d13db578: Declare 'succeeds_if' conditions to specify success criteria.
// 217f867eb14e8410bfd0f0da6000c3df: Test that pattern matching on a struct with field renaming correctly swaps values and returns expected tuples.
// 03fd8a218302bc1d5cff7e7d7e3ab67a: Use string literals beginning with 'b"' or 'x"' for byte and hex strings.
