//# publish
module 0xCAFE::VisibilityTest {
    struct Dummy has store {}

    // Function with public but type argument restricted visibility
    public<Dummy> fun public_visible_only_to_dummy(): u8 {
        42u8
    }

    // Function with friend visibility at custom address 0xBEEF
    friend 0xBEEF fun friend_only_at_beef(): u64 {
        0xBEEFu64
    }

    /// Generic function to be called freely
    public fun generic_function<T>(): T {
        // We cannot construct generic type directly.
        // So we just abort if called, only to test syntax.
        // abort with code 100 in case used accidentally.
        abort 100;
    }
}

//# run
script {
    use std::signer;
    use 0xCAFE::VisibilityTest;

    fun rebind_and_alias_refs() {
        let mut x = 10u8;
        let mut_ref = &mut x;

        // Binding a new mutable reference to the same location
        let new_mut_ref = mut_ref;
        *new_mut_ref = 20u8;

        // Aliasing mutable references by rebinding
        let mut alias_ref = new_mut_ref;
        *alias_ref = 30u8;

        // Just use to silence unused var warnings
        let dummy = *mut_ref + *new_mut_ref + *alias_ref;
    };

    // Call the function testing rebind and aliasing of mutable references
    rebind_and_alias_refs();

    // Calling public with type argument visibility - allowed
    let _res1 = VisibilityTest::public_visible_only_to_dummy();

    // Calling friend only at 0xBEEF address - should fail here if VM enforces
    // but transactional tests usually just run - so let's call but ignore error.
    // We can call but expect error, so just call in a block and ignore result.
    let _res2 = (
        // We use a dummy try-catch pattern in comments; Aptos VM does not have try-catch,
        // so just call it. Actual runtime check of friend visibility will block this if strict.
        // But for transactional test, just calling it exercises compilation.
        // In proper transaction, it would abort if signer is not 0xBEEF.
        // Here we call anyway for coverage.
        VisibilityTest::friend_only_at_beef()
    );
}

// Featurres:
// 1777d2d2a47c77ea699090f26b0c711f: Test re-binding and aliasing of mutable references within a script, ensuring correct reference assignment and dereference behavior.
// e92862de9389bf90c5f10cdf195228a6: Attach optional type arguments to access specifiers for generic visibility control.
// df82f3d049ccfcecf80883bfa2494d9d: Specify a custom address for access specifiers in visibility restrictions.
