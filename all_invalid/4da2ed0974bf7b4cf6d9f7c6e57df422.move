//# publish
module 0xA550C18::InlineLib {
    #[skip(arithmetic)]
    inline fun add_one(x: u64): u64 {
        x + 1
    }

    #[skip(type_check)]
    public fun runner(): u64 {
        // Call the inline function inline within this module
        add_one(41)
    }
}
//# run 0xA550C18::InlineLib::runner


//# publish
module 0xA550C18::Caller {
    use 0xA550C18::InlineLib;

    #[skip(unused_variable)]
    public fun call_inline(): u64 {
        // Call InlineLib::add_one inline function within another module's function
        InlineLib::add_one(58)
    }

    #[skip(code_duplicated)]
    public fun nested_call(): u64 {
        let v = Self::call_inline();
        // call the inline function again add_one on top of this
        InlineLib::add_one(v)
    }

    public fun runner(): u64 {
        Self::nested_call()
    }
}
//# run 0xA550C18::Caller::runner


//# publish
module 0xA550C18::ByteStringTest {
    #[skip(unused_imports)]
    public fun create_bytes() : vector<u8> {
        // Create a byte string literal with prefix b""
        b"hello aptos world"
    }

    public fun runner(): vector<u8> {
        Self::create_bytes()
    }
}
//# run 0xA550C18::ByteStringTest::runner


//# run
script {
    use 0xA550C18::ByteStringTest;
    use 0xA550C18::InlineLib;
    use 0xA550C18::Caller;

    fun main() {
        // Test byte string creation
        let bytes = ByteStringTest::create_bytes();

        // Test inline function call (direct call)
        let val1 = InlineLib::add_one(100);

        // Test inline function call from another module
        let val2 = Caller::call_inline();

        // Test nested inline function call and runner functions
        let val3 = Caller::runner();

        // Just reference val* variables avoid optimizations
        let _ = bytes;
        let _ = val1;
        let _ = val2;
        let _ = val3;
    }
}