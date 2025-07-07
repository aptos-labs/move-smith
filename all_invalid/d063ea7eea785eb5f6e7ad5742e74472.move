//==============================================================
// 1. Use an environment variable to enable or disable deprecation warnings
//    We'll use "#![env:MOVE_DISABLE_DEPRECATION_WARNING=1]" to disable warnings,
//    and introduce a deprecated function in a module.
//==============================================================

//# publish
#![env:MOVE_DISABLE_DEPRECATION_WARNING=1]
module 0xA1::DeprecationTest {
    #[deprecated = "use `bar` instead"]
    public fun foo(): u8 {
        42u8
    }

    public fun bar(): u8 {
        self::foo() + 1
    }

    // A public entry to call deprecated function (should not emit warnings due to the env setting)
    public entry fun call_deprecated(): u8 {
        self::foo()
    }
}

//# run 0xA1::DeprecationTest::call_deprecated --signers 0xA1

//==============================================================
// 2. Test that conditional expressions and boolean logic evaluate correctly, in assignments and assertions
//    We'll make a module with various public entry functions that use boolean conditions in expressions.
//==============================================================

//# publish
module 0xB2::BoolLogicTest {
    // Simple test of conditional (if-else) expression in assignments
    public entry fun assign_conditional() {
        let x = if true { 100u8 } else { 200u8 };
        let y = if false { 1u64 } else { 2u64 };
        // Also test boolean logic in assignment
        let b1 = true && false;
        let b2 = true || false;
        let b3 = !b1;

        // assert statements with conditions that should be true
        assert!(x == 100u8, 11);
        assert!(y == 2u64, 12);
        assert!(!b1, 13); // b1 is false
        assert!(b2, 14);  // b2 is true
        assert!(b3, 15);  // b3 is true
    }

    // A runner function that can be called to run all tests
    public entry fun run_all() {
        Self::assign_conditional();
    }
}

//# run 0xB2::BoolLogicTest::run_all --signers 0xB2

//==============================================================
// 3. Define a script with attributes and optional use declarations
//    We'll make a script with #[test_only] and #[abi(name = "...")], and use an alias and global declaration.
//==============================================================

//# run
script {
    use std::signer;
    use std::string::{Self, String as S};

    #[test_only]
    #[abi(name = "my_script_with_attributes")]
    fun main(a: &signer, b: u8) {
        let address_str = S::utf8(b"Hello World");
        let _ = signer::address_of(a);
        // No-op; focus is on attributes and usage syntax.
    }
}