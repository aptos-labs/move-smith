
//# publish
module 0xCAFE::RefSafetyTest {
    use std::vector;

    // This function demonstrates variable reassignment after move
    public fun test_reassignment(x: u64): u64 {
        let y = x; // move x into y
        let y = if (y > 10) {
            // y is valid here
            y + 1
        } else {
            // y is still valid here
            y + 2
        }; // end of if-else, y is reassigned
        y // last expression
    }

    // Reference safety analysis demonstration with an inline comment
    public fun ref_safety_analysis() {
        let vec: vector<u8> = vector::empty<u8>();
        // Borrow a reference to vec, which is safe
        let ref1: &vector<u8> = &vec; // safe reference
        // Mutably borrow, should be disallowed when immutable reference exists
        // The following line is intentionally unsafe to test analysis:
        // let ref_mut: &mut vector<u8> = &mut vec; // should trigger safety warning or error

        // Display information about references in comments
        // ref1 is an immutable borrow, safe to read
        // ref_mut is a mutable borrow; if active simultaneously with ref1, safety is violated
        // Move vec after refs to see if the compiler flags unsafe usage:
        let _moved_vec = vector::|vec| vec; // move occurs here; refs above are now stale
        // The bytecode annotation should display reference safety analysis result
    }
}


//# run 0xCAFE::RefSafetyTest::test_reassignment --args 15u64

//# run 0xCAFE::RefSafetyTest::ref_safety_analysis

// Featurres:
// d4dccfeee89ce45d6510a84b34380f76: Be warned that a spec module without an associated target module in the same compilation unit will result in a compilation error
// b0bb423b3ca1fb4d46acb223aba04828: Test that a variable can be reassigned after being moved from and used in an if-else control flow.
// c611388e3b33da0d46095b6087db59de: Display results of reference safety analysis directly in the bytecode annotations to spot unsafe reference usage.
