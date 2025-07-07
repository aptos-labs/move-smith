//# publish
module 0xCAFE::AbilitiesTest {
    use std::signer;

    /// A struct with multiple abilities declared sequentially, separated by commas.
    struct Data has key, store, drop {
        value: u64,
    }

    /// A struct with a generic type parameter that is not used in the struct fields.
    struct UnusedParam<T> has copy, drop {
        x: u8,
    }

    /// Function that creates and returns a Data resource
    public fun make_data(): Data {
        Data { value: 42 }
    }

    /// Function that exercises UnusedParam<T>
    public fun make_unused_param<T>(x: u8): UnusedParam<T> {
        UnusedParam { x }
    }

    /// A runner function with no arguments to cover the module
    public fun runner() {
        let d = make_data();
        let u = make_unused_param<u64>(7);
        // no-op just to call the functions
        let _ = d;
        let _ = u;
    }
}
//# run 0xCAFE::AbilitiesTest::runner --signers 0xCAFE

//# run
script {
    use std::signer;
    use 0xCAFE::AbilitiesTest;

    fun main(_account: signer) {
        // Call the module's runner directly to exercise the functions
        AbilitiesTest::runner();
    }
}

// Featurres:
// 91eebeae2016a8b9a56171751839e97e: Run the Move compiler with whole program analysis enabled.
// 9ec8e91bb42b5c81ffbf1c002cdcc6f5: Check for unused struct parameters.
// 949da64cd2f6ac426e454f9d89ed0665: Declare multiple abilities sequentially after the 'has' keyword, allowing for a comma-separated list.
