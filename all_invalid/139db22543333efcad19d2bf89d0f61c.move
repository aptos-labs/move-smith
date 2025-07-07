// Test for: 
// 1. Identifying unused private functions or functions with no friends
// 2. Using phantom type parameters to avoid unused warnings
// 3. Destructuring after abort to ensure immediate halt (code after abort is unreachable).

//# publish
module 0xA1::CleanupTest {
    // Used private function (should NOT warn)
    fun used_private() {
        // intentionally left unused code for coverage
    }

    // Unused private function (should WARN as unused)
    fun unused_private() { // this should trigger compiler warning
        let x = 10;
        let y = x + 1;
        // just some computation
    }

    // Not friend with anyone, only module-scoped, unused (should WARN)
    fun dead_function_only_for_test() {}

    // Runner to call the only used private function, via public API (should not warn)
    public fun call_used_private() {
        used_private();
    }

    // Runner, intentionally does NOT call unused_private (so warning should appear)
}

//# run 0xA1::CleanupTest::call_used_private --signers 0xA1

///////////////////////////////////////////////////////////////////////////////////////

//# publish
module 0xA2::PhantomTypeParamTest {
    // Phantom type used in struct to avoid unused type parameter warning
    struct S<phantom T> has copy, drop, store {}
    
    // Regular function to create S<u8>
    public fun make_s(): S<u8> {
        S {}
    }

    // If you remove 'phantom' the compiler will warn.
    // If you use 'phantom', even if phantom parameter is not referenced, NOT warn.

    // This tests that phantom avoids the unused type parameter warning.
}

//# run 0xA2::PhantomTypeParamTest::make_s --signers 0xA2

///////////////////////////////////////////////////////////////////////////////////////

//# publish
module 0xA3::DestructureAbortTest {
    struct MyStruct {
        val: u64,
    }

    // Runner
    public entry fun abort_then_destructure() {
        let s = MyStruct { val: 123 };
        abort 100; // Execution must stop here
        let MyStruct { val: v } = s; // Should not be reached, should NOT destructure
        // (Any code here is dead; compiler/VM should ensure that code is unreachable after abort)
    }
}

//# run 0xA3::DestructureAbortTest::abort_then_destructure --signers 0xA3

///////////////////////////////////////////////////////////////////////////////////////

//# run
script {
    use 0xA2::PhantomTypeParamTest;
    fun main() {
        let _s = PhantomTypeParamTest::make_s();
    }
}

//# run
script {
    use 0xA3::DestructureAbortTest;
    fun main() {
        DestructureAbortTest::abort_then_destructure();
    }
}