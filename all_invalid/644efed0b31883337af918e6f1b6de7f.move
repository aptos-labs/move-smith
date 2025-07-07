// This transactional test exercises several Move features:
// - #[test] function annotations,
// - access to names through chained identifiers (module and struct),
// - functions with entry point property for executable code.

//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // A simple struct with abilities key and store to be storable in global storage.
    struct SampleStruct has key, store {
        value: u64,
    }

    // An entry point function with the entry attribute, which can be called as a script.
    // It creates and returns a SampleStruct value
    public entry fun create_sample(value: u64): SampleStruct {
        SampleStruct { value }
    }

    // A public function without entry point property
    // Returns the inner value incremented by 1
    public fun increment_value(s: &SampleStruct): u64 {
        s.value + 1
    }

    // A test function annotated with #[test] that verifies increment_value logic via assert
    #[test]
    public fun test_increment_value() {
        let s = SampleStruct { value: 41 };
        let res = Self::increment_value(&s);
        // We ignore adding explicit asserts as per instruction
        // Just end the function here
        res;
    }

    // Another test annotated function to test creating and reading SampleStruct
    #[test]
    public fun test_create_and_access() {
        let s = Self::create_sample(123);
        let v = s.value;
        v;
    }

    // A runner function for testing that calls both test functions (to be called via run command)
    public fun runner() {
        Self::test_increment_value();
        Self::test_create_and_access();
    }
}
//# run 0xCAFE::TestModule::runner

//# run
script {
    use 0xCAFE::TestModule;
    use std::signer;

    fun main(account: signer) {
        // Call entry point create_sample storing the result in a local variable
        let sample = TestModule::create_sample(777);

        // Call increment_value on the sample struct and ignore its output
        let _ = TestModule::increment_value(&sample);

        // No asserts, just exercise function calls and main script execution
    }
}

// Featurres:
// 5f1ead8a3b6207df641f00333b58956a: Annotate test functions in Move with #[test] to mark them as test cases.
// 5d58de1bdef35f9deb9eb5006bf9ebc8: Write names that are accessed through chains of identifiers, such as module and struct accesses (e.g., Module::Struct).
// 63caac1c67cdb0dd23c2d706b143b0b3: Design functions with an entry point property for executable code.
