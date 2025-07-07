//# publish
module 0xCAFE::TestModule {
    // A simple struct with abilities key, store, drop to be storable in global storage and droppable
    struct SampleStruct has key, store, drop {
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

    // A runner function for testing that calls both test functions (to be called via run command)
    public fun runner() {
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
    fun main(account: signer) {
        // Call entry point create_sample storing the result in a local variable
        let sample = 0xCAFE::TestModule::create_sample(777);

        // Call increment_value on the sample struct and ignore its output
        let _ = 0xCAFE::TestModule::increment_value(&sample);

        // No asserts, just exercise function calls and main script execution
    }
}