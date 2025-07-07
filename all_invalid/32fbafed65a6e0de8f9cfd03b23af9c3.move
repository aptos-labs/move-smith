// Directory: modules/

//# publish
module 0xCAFE::UnitTest {
    use std::debug;
    use std::string;

    // A struct that we will debug-print. It implements AstDebug by default.
    struct TestStruct has copy, drop {
        field1: u8,
        field2: u64,
    }

    // A function to exercise print + debug
    public fun print_struct() {
        let s = TestStruct { field1: 10, field2: 5678 };
        debug::print(&s);
    }

    // Typical unit test functions in Move have the #[test] attribute, but for transactional
    // tests, we'll export a test-like runner function.
    public entry fun test_runner() {
        Self::print_struct();
    }
}

//# run 0xCAFE::UnitTest::test_runner --signers 0xCAFE

// Directory: scripts/

//# run
script {
    use std::debug;
    use std::vector;
    use std::string;

    // To test compiling scripts separately, show printing a vector.
    fun main() {
        let v = vector[5u8,7u8,9u8];
        debug::print(&v); // Vec<u8> implements AstDebug.
        let s = string::utf8(b"move transactional test");
        debug::print(&s);
    }
}