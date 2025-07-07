// This transactional test will test Move compiler and VM:
// 1. Assign to local variables and see if modifications are handled correctly.
// 2. Scripts with attributes, uses, constants, functions, and specifications.
// 3. Intentionally incorrect list syntax to check diagnostic error reporting.

//# publish
module 0xCAFE::VarAssignTest {
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
        debug::print(&vector::utf8(&std::string::utf8(result)));
        result
    }
}
//# run 0xCAFE::VarAssignTest::runner

//# run
script {
    use std::debug;
    use 0xCAFE::VarAssignTest;

    #[test_only]
    fun main() {
        // Use attribute #[test_only] in script function

        // Calls module function with local var assignments internally
        let res = VarAssignTest::modify_locals(10);

        // Print the result
        debug::print(&vector::utf8(b"Result from script main: "));
        debug::print(&vector::utf8(&std::string::utf8(res)));

        // No return, it's a script main function
    }
}


// The below should fail with diagnostic error - incorrect list syntax.
// We add this last to check compiler diagnostics.

//# publish
module 0xCAFE::BadListSyntax {
    // Intentionally bad list syntax in a constant vector declaration to test error messages

    const BAD_LIST: vector<u8> = [1, 2 3]; // Missing comma between 2 and 3, should fail
}
// Expected diagnostics:
// error: expected comma in vector literal between elements at line with BAD_LIST


// Featurres:
// 95da328130e16aabefd3d765a2e6f02a: Assign to local variables and detect if their values might be modified in a function's body.
// 2547807e4d5b91edc1a1d1eabd2344db: Write scripts that include attributes, uses, constants, functions, and specifications.
// efa6041ea0deaa30b1a289263862ca3b: Report errors with diagnostic messages if list syntax is incorrect.
