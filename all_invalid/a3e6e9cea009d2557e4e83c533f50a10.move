//# publish
module 0xCAFE::StringBytesTest {
    use std::string;
    use std::vector;
    use std::ascii;

    /// A resource holding some serialized data
    #[verifier(ignore)] // verification attribute ignoring this resource in verification
    resource struct SerializedData {
        data: vector<u8>,
    }

    /// Verification attribute on function requiring it to be verified
    #[verifier::inline(always)]
    #[inline(always)]
    fun utf8_bytes(key: u8): vector<u8> {
        // Convert key (u8) to a single char ASCII, then to UTF-8 bytes
        vector::singleton(key)
    }

    #[verifier::inline(never)]
    #[inline(never)]
    fun serialize_val(val: u64): vector<u8> {
        // Simply convert the u64 to vector<u8> little endian bytes
        let mut res = vector::empty<u8>();
        let n_bytes = 8;
        let mut i = 0;
        while (i < n_bytes) {
            vector::push_back(&mut res, (val >> (i * 8)) as u8);
            i = i + 1;
        }
        res
    }

    #[verifier::inline(always)]
    #[inline(always)]
    fun concat(a: &vector<u8>, b: &vector<u8>): vector<u8> {
        let mut res = vector::empty<u8>();
        let len_a = vector::length(a);
        let i = 0;
        while (i < len_a) {
            vector::push_back(&mut res, *vector::borrow(a, i));
            i = i + 1;
        }
        let len_b = vector::length(b);
        let i = 0;
        while (i < len_b) {
            vector::push_back(&mut res, *vector::borrow(b, i));
            i = i + 1;
        }
        res
    }


    /// Initialize and publish a SerializedData resource with serialized key and value
    fun init_internal(account: &signer, key: u8, val: u64) {
        // Convert key to UTF-8 bytes via utf8_bytes (inline(always))
        let key_bytes = utf8_bytes(key);
        // Serialize val to bytes (inline(never))
        let val_bytes = serialize_val(val);
        // Concatenate
        let serialized = concat(&key_bytes, &val_bytes);
        move_to(account, SerializedData { data: serialized });
    }

    /// Runner function that publishes SerializedData resource under caller with key=65('A') and val=0x1234567890ABCDEF
    public fun runner(account: &signer) {
        init_internal(account, 65, 0x1234567890ABCDEF);
    }
}
//# run 0xCAFE::StringBytesTest::runner --signers 0xCAFE


//# publish
module 0xCAFE::VerifierAnnotations {
    /// Use verifier attribute to prevent modification of a resource
    #[verifier::unchanged]
    resource struct ImmutableResource {
        value: u64,
    }

    /// Resource with an invariant (simulate verification attribute)
    #[verifier::invariant(SELF.value > 0)]
    resource struct PositiveValue {
        value: u64,
    }

    /// Function that does nothing but is marked as inline(always)
    #[verifier::inline(always)]
    #[inline(always)]
    fun always_inline() {
        // no-op
    }

    /// Function marked as inline(never) that returns sum of two u64
    #[verifier::inline(never)]
    #[inline(never)]
    public fun add_never_inline(a: u64, b: u64): u64 {
        a + b
    }

    /// Initializes both resources with verification attributes
    public fun init(account: &signer) {
        always_inline();
        move_to(account, ImmutableResource { value: 42 });
        move_to(account, PositiveValue { value: 10 });
    }

    /// Runner function that calls init to publish the resources (inline attribute functions inside)
    public fun runner(account: &signer) {
        init(account);
        let sum = add_never_inline(40, 2);
        // Just use sum to prevent unused warnings (no assertions)
        let _ = sum;
    }
}
//# run 0xCAFE::VerifierAnnotations::runner --signers 0xCAFE



//# run
script {
    use 0xCAFE::StringBytesTest;
    use 0xCAFE::VerifierAnnotations;

    fun main(account: &signer) {
        // Run the runner functions in both modules
        StringBytesTest::runner(account);
        VerifierAnnotations::runner(account);
    }
}

// Featurres:
// 9585f3c6aba18205e6693baebb28cdc6: Test that the `init` function successfully converts defined keys to UTF-8 strings and serializes values to bytes.
// 7de5c415f36b52af2275191ee808773b: Use verification attributes in your code to annotate functions or resources with specific verification requirements.
// 296137f73b01ca107f2e516f6e55c58b: Use function inlining and control whether to keep or lift inline functions
