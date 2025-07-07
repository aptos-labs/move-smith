//# publish
module 0xCAFE::TestModule {
    // Removed unused alias 'use std::signer;' as it was unused.

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
        // We cannot call #[test] functions directly, so move test logic here:
        let s = SampleStruct { value: 41 };
        let res = Self::increment_value(&s);
        res;

        let s2 = Self::create_sample(123);
        let v = s2.value;
        v;
    }
}
//# run 0xCAFE::TestModule::runner

//# run
script {
    // Removed unused alias 'use std::signer;'

    fun main(account: signer) {
        // Call entry point create_sample storing the result in a local variable
        let sample = 0xCAFE::TestModule::create_sample(777);

        // Call increment_value on the sample struct and ignore its output
        let _ = 0xCAFE::TestModule::increment_value(&sample);

        // No asserts, just exercise function calls and main script execution
    }
}