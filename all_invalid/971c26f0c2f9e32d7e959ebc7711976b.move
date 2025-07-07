//# publish
module 0xCAFE::VisibilityTest {
    use std::signer;

    struct Data has store {
        val: u64,
    }

    // public(script) function callable only from script
    public(script) fun script_only_function(x: u64, y: u64): u64 {
        x + y
    }

    // public function callable from anywhere
    public fun public_function(x: u64, y: u64): u64 {
        x * y
    }

    // public(script) function to create and store Data resource at signer's address
    public(script) fun create_data(s: signer, val: u64) {
        let d = Data { val };
        move_to<Data>(&s, d);
    }

    // public(script) function to read Data resource from signer's address
    public(script) fun read_data(s: signer): u64 {
        let d_ref = borrow_global<Data>(signer::address_of(&s));
        d_ref.val
    }

    // public function returning a tuple
    public fun get_tuple(x: u64): (u64, u64) {
        (x, x * 2)
    }

    // A runner function with no arguments for completeness
    public(script) fun runner() {
        let _ = script_only_function(2, 3);
        let _ = public_function(2, 5);
        // no return, just call functions to exercise call syntax and visibility
    }
}

//# run 0xCAFE::VisibilityTest::runner

//# run 0xCAFE::VisibilityTest::script_only_function --args 10u64 20u64

//# run 0xCAFE::VisibilityTest::public_function --args 10u64 20u64

//# run 0xCAFE::VisibilityTest::create_data --signers 0xBEEF --args 42u64

//# run 0xCAFE::VisibilityTest::read_data --signers 0xBEEF

//# run 0xCAFE::VisibilityTest::get_tuple --args 100u64

// Featurres:
// 88ceccc11badb151db840f1c6e73b577: Call functions or constructors using parentheses with arguments (e.g., `function(arg1, arg2)`).
// 5455ff75a13c9b6d4b39759d22407b1d: Restrict visibility of functions and modules to scripts using the 'public(script)' visibility modifier.
// e83f6a8bcd3956b69924e8227de41daa: Define function signatures with parameter and return types.
