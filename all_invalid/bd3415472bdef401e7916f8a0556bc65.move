//# publish
module 0x1::TestModule {
    use std::phantom;
    use std::debug;

    /// A struct with two fields and a phantom type parameter.
    struct MyStruct<TPhantom, T> has copy, drop, store {
        _phantom: phantom::Phantom<TPhantom>,
        value: T,
        id: u64,
    }

    /// SourceLocation struct from std::debug for convenience.
    /// // actual definition:
    /// // struct SourceLocation has copy, drop, store {
    /// //   file_hash: vector<u8>,
    /// //   start_pos: u64,
    /// //   end_pos: u64,
    /// // }
    /// 
    /// We'll create one using std::debug::SourceLocation::new

    /// runner function (@0x1)
    public fun runner(account: &signer) {
        // Create a MyStruct with phantom param u8 and T = bool
        let s = MyStruct {
            _phantom: phantom::Phantom<u8> {},
            value: true,
            id: 42,
        };

        // Unpack struct partially in an assignment
        let MyStruct { value, .. } = s;

        // Use the unpacked value (just dummy use to get it involved)
        let _v: bool = value;

        // Construct a source_location with a fixed file hash and positions
        let file_hash = b"testfilehash0123456789abcdef0123456789abcdef0123456789abcdef01234567";
        // use first 32 bytes of that slice
        let file_hash_vec = vector::slice(file_hash, 0, 32);

        let loc = debug::SourceLocation::new(file_hash_vec, 100, 200);

        // dummy use loc fields (not mandatory)
        let _start = loc.start_pos;
        let _end = loc.end_pos;

        // no returns needed for the runner
    }
}
//# run 0x1::TestModule::runner --signers 0x1

//# run
script {
    use 0x1::TestModule;

    fun main(account: &signer) {
        // run the runner function to test unpack + phantom + source_location
        TestModule::runner(account);
    }
}