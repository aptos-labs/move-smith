//# publish
module 0xCAFE::TestDiagnostics {
    use std::vector;
    use std::string;

    /// Returns a byte vector containing a formatted diagnostic message
    public fun get_diagnostic_bytes(): vector<u8> {
        let msg = "Error: Something went wrong";
        let bytes = string::utf8(msg);
        bytes
    }
}

//# publish
module 0xCAFE::TestInlineFun {
    /// An inline function that applies a passed-in function `f` to value `x`
    inline fun foo<T: copy, R>(x: T, f: &fun(T): R): R {
        f(x)
    }

    /// A helper function that adds 1 to a u8
    public fun add1(x: u8): u8 {
        x + 1
    }

    /// The main function tests that foo(add1, 2) == 3
    public fun main() {
        let f = &Self::add1;
        let res = foo<u8, u8>(2, f);
        // Following assert is here to exercise bytecode, no error handling needed
        assert!(res == 3, 1);
    }
}

//# publish
module 0xCAFE::TestSelfAlias {
    /// Using the self alias of the module to call `helper`
    public fun caller(): u64 {
        Self::helper()
    }

    fun helper(): u64 {
        42
    }
}

//# run 0xCAFE::TestDiagnostics::get_diagnostic_bytes

//# run 0xCAFE::TestInlineFun::main --signers 0xCAFE

//# run 0xCAFE::TestSelfAlias::caller

// Featurres:
// bb5d4592f2188bdb68d5196965acc999: Generate a buffer containing formatted diagnostic messages
// 1b2ddea6cb5c2d7b6c8217aaefcf1d5f: Test that the inline function `foo` correctly applies a passed-in function to a value and that the `main` function asserts the result equals 3.
// df2e4d6bd25d7115c418ac22aba0d387: Use the module self-alias to refer to the current module by its designated self name.
