//# publish
module 0xCAFE::SpecTest {

    use std::error;
    use std::vector;
    use std::string;

    // A struct just for demonstration
    struct Demo has copy, drop, store {
        val: u64,
    }

    // A function to test spec blocks with assignment and forall quantifiers
    public fun runner() {
        // intentionally empty
    }

    // This function to use error reporting with writer
    public fun error_writer_demo(): error::Error {
        error::abort_code(42)
    }

    // Spec block showing assign-by-expression with '=' and forall quantifier
    spec module {
        // a global spec variable
        var x: u64;
        var f: bool;

        invariant forall i: u64;
            i < 10 ==> exists Demo d; d.val == i;

        // a spec function that assigns a value to x
        fun set_x() {
            x = 5;
            f = forall i: u64; i < 5 ==> true;
        }
    }
}

//# run 0xCAFE::SpecTest::runner --signers 0xCAFE

//# run 0xCAFE::SpecTest::error_writer_demo --signers 0xCAFE


//# run
script {
    use std::error;

    fun main(account: &signer) {
        // abort with a custom error to test error reporting
        error::abort_code(999);
    }
}

// Featurres:
// 7cc49543fa09eb05657b36151d8d9960: Write specification block update statements that assign one expression to another using the '=' syntax inside Move spec blocks
// fe9389b33d5c39d4508f4bdeb40560ab: Declare universal quantifiers using the syntax 'forall'.
// 998fbe7952135a22ff05716135a83301: Configure error reporting to output errors to a specified writer.
