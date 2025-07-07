//# publish
module 0xCAFE::AcquisitionTest {
    use std::signer;

    struct Acq has key, store {
        id: u64,
    }

    /// public inline function to create Acq struct
    public inline fun create_acq(id: u64): Acq {
        Acq { id }
    }

    /// public inline function to validate id is not zero
    public inline fun validate_id(id: u64) {
        assert!(id != 0, 1);
    }

    /// public function demonstrating inline calls in bottom-up order
    public fun make_acq(id: u64): Acq {
        validate_id(id);
        create_acq(id)
    }

    /// function to test resource acquisition: moves resource out and returns it
    public fun acquire(s: &signer, id: u64): Acq {
        let acq = make_acq(id);
        move_to<Acq>(s, acq);
        let resource = withdraw(s);
        resource
    }

    /// withdraw resource of type Acq from global storage
    public fun withdraw(s: &signer): Acq acquires Acq {
        let acq = move_from<Acq>(signer::address_of(s));
        acq
    }

    /// runner function with no arguments for easy testing
    public fun runner() {
        let dummy_signer = @0xCAFE;
        // Create signer reference - this is a test playground style, simulate signer for calling acquire
        // In actual Aptos environment, signer is passed by VM

        // We cannot create signer in pure Move, so just skip acquire call here,
        // and just call make_acq to test inline chain.

        let _ = make_acq(42);
    }
}
//# run 0xCAFE::AcquisitionTest::runner

//# run 0xCAFE::AcquisitionTest::acquire --signers 0xCAFE --args 100u64

//# run
script {
    use std::signer;
    use 0xCAFE::AcquisitionTest;

    fun main(account: signer) {
        // Test acquisition by calling acquire function to store and withdraw resource
        let res = AcquisitionTest::acquire(&account, 1);

        // Test inline functions through make_acq
        let acq = AcquisitionTest::make_acq(10);

        // Use the id in a byte string to test ASCII-only byte string usage
        let id_bytes: vector<u8> = b"Resource ID: ";
        // No non-ASCII chars used, only ASCII in byte strings

        // Consume values (no assertions needed as per instructions)
        let _ = res;
        let _ = acq;
        let _ = id_bytes;
    }
}

// Featurres:
// 7cb9e69f486261eb0a12a25ab96bab61: Check for proper acquisition annotations in code.
// 9a4f6586c3a8471e51b539c30c0736b8: Ensure inline functions are called in bottom-up order so that inline functions are processed before the functions that call them.
// 44c581ac2d6f93070719f88426073f6d: Use ASCII characters only in byte strings.
