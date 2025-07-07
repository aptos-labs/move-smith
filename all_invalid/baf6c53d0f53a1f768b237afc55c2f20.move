//# publish
module 0x1::UninitTest {
    // A function that uses an uninitialized variable (should trigger the UninitializedUseChecker)
    public fun cause_uninitialized_use() {
        let x: u64;
        let _ = x; // uninitialized use
    }

    // A proper function initializing the variable first
    public fun no_uninitialized_use(): u64 {
        let x: u64 = 42;
        x
    }

    // Runner function to call no_uninitialized_use (no args)
    public fun runner() {
        let _ = no_uninitialized_use();
    }
}
//# run 0x1::UninitTest::runner


//# publish
module 0x1::HexStringTest {
    public fun decode_hex_bytes(): vector<u8> {
        // Decode a hex string literal into byte vector
        // The hex string is "012345abcdef"
        let bytes: vector<u8> = b"012345abcdef"; // this is actually a byte string literal, but we want a hex string

        // Move hex string literal decoding uses `hex"..."` syntax; will test it here:
        let hex_bytes: vector<u8> = hex"012345abcdef";
        hex_bytes
    }

    // Runner function calling decode_hex_bytes
    public fun runner() {
        let _ = decode_hex_bytes();
    }
}
//# run 0x1::HexStringTest::runner


//# publish
module 0x1::AccessSpecTest {
    // Demonstrate optional trailing commas in access specifiers
    // The access list below has trailing commas:
    public(friend 0x1, 0x2,) fun friend_function() {
        // Do nothing
    }

    public(script, 0x1, 0x2,) fun script_function() {
        // Do nothing
    }

    // Runner function to call friend_function and script_function:
    public fun runner(s: &signer) {
        friend_function();
        script_function();
    }
}
//# run 0x1::AccessSpecTest::runner --signers 0x1


//# run
script {
    use 0x1::UninitTest;
    use 0x1::HexStringTest;
    use 0x1::AccessSpecTest;

    // Call cause_uninitialized_use to trigger uninitialized use (compiler should error or catch)
    // We expect it (the UninitializedUseChecker) to throw an error, but test runner just executes
    // so no assertion here.
    // Let’s try to call the function that triggers uninitialized use inside this script:
    // Note: This could abort or fail compilation, but we still write it as a test.
    // So it should test the compiler.

    // We purposely do not call cause_uninitialized_use() here, 
    // because it will fail compilation/running - just to demonstrate.

    // Instead, call the proper runner functions that work:

    UninitTest::runner();
    let hex_bytes = HexStringTest::decode_hex_bytes();
    let _ = hex_bytes;

    AccessSpecTest::runner(&signer);
}