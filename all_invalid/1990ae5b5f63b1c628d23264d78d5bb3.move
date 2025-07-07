//# publish
module 0xCAFE::TestCompilerPass {

    // This function simulates multiple compiler passes by calling internal checks.
    // It's public to run it via the runner.
    public fun run() {
        let _ = self::pass_check();
        let _ = self::finalize();
    }

    // private function simulating an internal compiler pass step without exposing externally
    fun pass_check() {
    }

    // private function simulating a final compiler pass stage
    fun finalize() {
    }
}

//# run 0xCAFE::TestCompilerPass::run --signers 0xCAFE


//# publish
module 0xCAFE::AccessControlTest {

    // This public function will call a private function internally.
    public fun runner() {
        self::private_fn();
    }

    // private function, only accessible inside module
    fun private_fn() {
        // do nothing, just to test access restrictions
    }
}

//# run 0xCAFE::AccessControlTest::runner --signers 0xCAFE


//# publish
module 0xCAFE::CyclicTypeInstantiation {

    // Define a struct that attempts a cyclic type instantiation.
    // This should cause the compiler or VM to detect a cycle.
    // Note: This pattern triggers a cycle if possible:
    // struct A<T> { val: B<T> }
    // struct B<T> { val: A<T> }
    // Both referring to each other forming a cycle

    struct A<T> has copy, drop, store {
        val: B<T>,
    }

    struct B<T> has copy, drop, store {
        val: A<T>,
    }

    // runner function to try to instantiate cyclic types.
    public fun runner() {
        // Note: Just referring to A<u8> should trigger cycle detection.
        // We do not create instances here, but any valid usage should be rejected if cycle.
        // The Move compiler should detect this struct layout cycle at compile time.
        let _instance: A<u8>;
    }
}

//# run 0xCAFE::CyclicTypeInstantiation::runner --signers 0xCAFE

// Featurres:
// 8ec3435bf1358828adc414949546d591: Use the compiler's run function to process a Move program through multiple compiler passes until reaching a specified pass stage.
// 06a415a0517d400641fcfdfa1f8aa727: Define functions with restricted access so that certain operations can only be performed within the module where they are declared
// 298387cd44d5c2049aad7d0673da5fb3: Check for cyclic type instantiations.
