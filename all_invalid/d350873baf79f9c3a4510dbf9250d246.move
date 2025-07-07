//# publish
module 0xCAFE::VarAssignTest {
    use std::vector;
    use std::string;
    use std::debug;

    // Constant testing
    const CONST_VAL: u64 = 42;

    /// Test function to assign and modify locals
    public fun modify_locals(x: u64): u64 {
        let a = x + CONST_VAL;  // assign initial sum
        let b = a * 2;          // assign doubled value
        let a = b - x;          // reassign a with another calculation
        a // return a
    }

    public fun runner(): u64 {
        let initial = 5;
        let result = modify_locals(initial);
        debug::print(&vector::utf8(b"modify_locals result: "));
        debug::print(&string::utf8(result));
        result
    }
}
//# run 0xCAFE::VarAssignTest::runner

//# run
script {
    use std::debug;
    use 0xCAFE::VarAssignTest;

    fun main() {
        // Calls module function with local var assignments internally
        let res = VarAssignTest::modify_locals(10);

        // Print the result
        debug::print(&std::vector::utf8(b"Result from script main: "));
        debug::print(&std::string::utf8(res));
    }
}

//# publish
module 0xCAFE::BadListSyntax {
    // Intentionally bad list syntax in a constant vector declaration to test error messages

    const BAD_LIST: vector<u8> = [1, 2 3]; // Missing comma between 2 and 3, should fail
}
// Expected diagnostics:
// error: expected comma in vector literal between elements at line with BAD_LIST