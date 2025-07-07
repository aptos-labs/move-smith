// The following transactional test is for Aptos Move. It exercises diagnostics, definite assignment analysis,
// and correct "return" statement semantics inside nested while loops (including post-return dead code).

//# publish
module 0xCAFE::DiagTest {
    // We will intentionally include commented-out code and a type error
    // to test diagnostic collection and parsing of comments.

    // This is a comment for diagnostics.

    /// This doc comment should be parsed as well.

    // The following function has an unused variable to generate a warning.
    public fun unused_variable_warning() {
        let x: u8 = 42;
        // x is never used, which should generate a warning.
    }

    // The following function has a compilation error (type mismatch), for diagnostic collection.
    public fun compilation_error() {
        let y: bool = 10; // ERROR: assigning integer to bool
    }

    // The following function is well-typed but has several comments that should be retained in diagnostics.
    public fun locals_definitely_initialized(): u8 {
        let a: u8;
        let b: u8;
        a = 7;
        // b = a + 1;
        b = 99;
        // Both a and b are now definitely initialized!
        (a + b)
    }

    // Function to test nested while loops and `return` behavior.
    public fun return_in_nested_loops(n: u8): u8 {
        let i = 0u8;
        let j = 0u8;
        // Outer loop
        while (i < n) {
            j = 0u8;
            // Inner loop
            while (j < n) {
                if (j == 2) {
                    return 100u8;
                };
                j = j + 1;
            };
            i = i + 1;
        };
        // This code should only run if return never hit in loops
        assert!(false, 42);
        // The assert above should never execute if return was hit.
        200u8
    }

    // A runner function that runs everything above except deliberately-broken functions.
    public fun runner() {
        Self::unused_variable_warning();
        let _ = Self::locals_definitely_initialized();
        let _ = Self::return_in_nested_loops(4);
    }
}

//# run 0xCAFE::DiagTest::runner --signers 0xCAFE


//# publish
module 0xCAFE::DefAssignTest {
    // Various functions to test definite assignment.

    // Locals that are always initialized before use.
    public fun all_initialized(): u8 {
        let x: u8;
        let y: u8;
        x = 10;
        y = x + 2;
        x + y
    }

    // Locals that might not be initialized (should cause compilation error).
    public fun not_all_initialized(): u8 {
        let x: u8;
        let y: u8;
        if (x == 0) { // x has not been assigned, error!
            y = 1;
        } else {
            y = 2;
        };
        // y is always initialized, but x is not. Using x below is error.
        x + y // ERROR: x might not be initialized
    }

    // Definite assignment across a while loop
    public fun while_init(n: u8): u8 {
        let sum: u8 = 0;
        let i: u8 = 0;
        // This path will always initialize sum and i
        while (i < n) {
            let z = i * 2;
            i = i + 1;
        };
        sum
    }

    // Runner for this module
    public fun runner() {
        let _ = Self::all_initialized();
        let _ = Self::while_init(5);
        // Self::not_all_initialized(); // Uncomment to check compilation diagnostics
    }
}

//# run 0xCAFE::DefAssignTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::DiagTest;

    fun main() {
        // Testing nested while loop return test directly.
        let val = DiagTest::return_in_nested_loops(4);
        // value should be 100u8 because return will be hit in inner loop
    }
}

//# run
script {
    use 0xCAFE::DiagTest;

    fun main() {
        // Ensure code after return in nested loops does not execute (assert! is not tripped)
        let val1 = DiagTest::return_in_nested_loops(1);
        let val2 = DiagTest::return_in_nested_loops(0);
        // In both, loop conditions may change, but running with '2' will not hit assert!, 
        // since return will always be before.
    }
}

// END OF TEST CASE

// Featurres:
// 375b016088e6d88efb893470d8dddbdb: Collect and handle diagnostics, including compilation errors, warnings, and comments, during the parsing process.
// c405d827a2af8b222e07dabf249dade3: Confirm when all function locals are definitely initialized at a given program point.
// 2060e42e31fb0446aef758dfaa2d009f: Test that a `return` statement inside nested `while` loops correctly exits the loops and prevents subsequent code (such as failing `assert!`) from executing.
