//# publish
module 0x1::UninitUseTest {
    use std::signer;

    /// This function attempts to use an uninitialized local variable. 
    /// The compiler's UninitializedUseChecker should flag this usage.
    public fun uninit_use() {
        // Declare a local variable but do not initialize it
        let x: u64;
        // This should cause an error, as x is uninitialized
        let _ = x;
    }

    /// Runner function that does nothing but exists for running context
    public fun runner() {}
}
//# run 0x1::UninitUseTest::runner

//# publish
module 0x1::StringLiteralTest {
    /// A function returning a string literal with complex escape sequences
    public fun get_string(): vector<u8> {
        // The string contains escaped double quotes and a newline
        // Compiler must correctly identify the closing quote position
        let s = b"Hello \"world\"\n";
        s.to_vec()
    }

    public fun runner() {}
}
//# run 0x1::StringLiteralTest::runner

//# publish
module 0x1::AccessSpecCommaTest {
    // This module defines a struct with multiple abilities,
    // The abilities list includes an optional trailing comma
    struct S has copy, drop, store, {}

    public fun runner() {}
}
//# run 0x1::AccessSpecCommaTest::runner


//# run
script {
    use 0x1::UninitUseTest;
    use 0x1::StringLiteralTest;
    use 0x1::AccessSpecCommaTest;

    fun main(signer: signer) {
        // We do not call uninit_use() because it should fail compilation
        // Just call runner functions to exercise module publishing.
        UninitUseTest::runner();
        let s = StringLiteralTest::get_string();
        AccessSpecCommaTest::runner();
    }
}