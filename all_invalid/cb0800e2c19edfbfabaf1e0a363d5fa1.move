module 0x1::TestTransaction {

    /// A struct defined in this module
    struct MyStruct has copy, drop, store {
        value: u64,
    }

    /// A constant defined in this module
    const MY_CONST: u64 = 42;

    /// A public function that returns the constant
    public fun get_const(): u64 {
        MY_CONST // 1: referencing module access path as a value identifier
    }

    /// Specification with axioms
    spec MyStruct {
        /// An axiom about MyStruct's value field: it must always be non-negative (u64 is always >=0, trivial axiom)
        axiom value_nonnegative(v: MyStruct) {
            v.value >= 0
        }

        /// Another axiom associating value and MY_CONST
        axiom constant_relation(v: MyStruct) {
            v.value <= TestTransaction::MY_CONST
        }
    }

    /// A function that uses `access_warning` if called from outside this module
    public fun sensitive_action() acquires MyStruct {
        // Check if caller module is not 0x1::TestTransaction,
        // then issue a warning.
        // access_warning(condition: bool, msg: vector<u8>): ()
        let caller_address = @0x1; // We'll simulate the module here (in real VM, this is handled automatically)
        // For demonstration: if caller_address != 0x1 (the module here), issue a warning.
        // Since we cannot programmatically access caller address here,
        // let's just call access_warning with a false condition to show syntax.
        access_warning(false, b"Warning: sensitive_action called outside defining module");

        // Perform some state changes
        let s = MyStruct { value: MY_CONST };
        // do something with s, e.g., return or drop (here just drop)
        drop(s);
    }

    #[test_only]
    public fun transactional_test() {
        // 1. Referencing a name/module access path
        let v = TestTransaction::get_const();
        assert!(v == 42, 1);

        // 2. Using axioms means spec blocks and the verifier check them (cannot test dynamically),
        // but we can create a value satisfying the axiom.
        let s = MyStruct { value: 40 };
        assert!(s.value <= TestTransaction::MY_CONST, 2);

        // 3. Test access_warning usage:
        // Call sensitive_action (we are inside 0x1::TestTransaction, so no warning should be emitted at runtime)
        sensitive_action();

        // Instead, we forcibly call access_warning with true condition to simulate warning emission
        access_warning(true, b"This is a forced warning for testing purposes");
    }
}

// Featurres:
// 3f966e77979cf7ab5e1b615df0be442e: Reference a name or module access path as a value or identifier (e.g., some_identifier or M::some_identifier).
// 49b4b441ae2849b6cc3fddf30f4eaf8c: Add axioms to your specification by using the 'axiom' keyword in a spec block.
// 43025b6126a497c589dc9cf1c4ac9828: Use the `access_warning` function to issue warnings when some actions are attempted outside of their defining module.
