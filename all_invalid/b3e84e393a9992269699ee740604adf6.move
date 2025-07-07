
//# publish
module 0xCAFE::InteractionTest {
    use std::vector;

    // Nested data structure with nested fields for dot notation tests
    struct NestedStruct has copy, drop, store {
        inner: InnerStruct,
        count: u64,
    }

    struct InnerStruct has copy, drop, store {
        a: u64,
        b: u64,
    }

    // A private function to test internal visibility restrictions
    fun internal_increment(n: &mut u64) {
        *n = *n + 1;
    }

    // Public function that internally calls the private function
    public fun update_count(ns: &mut NestedStruct) {
        internal_increment(&mut ns.count);
    }

    // Function with pre- and post-conditions (specifications) enforcing invariants
    public fun process_struct_with_specs(ns: &mut NestedStruct)
        has {
            // Precondition: count should be less than 100
            ensures: ns.count < 100,
        }
    {
        // Nested field access with dot notation: update inner.a
        ns.inner.a = ns.inner.a + 10;
        // Increment count using internal function
        update_count(ns);
        // Postcondition: after update_count, count increased by 1
        assert!(ns.count > 0, 9999);
    }

    // Helper to create a new NestedStruct instance
    public fun new_nested_struct(a: u64, b: u64, count: u64): NestedStruct {
        let inner = InnerStruct { a, b };
        NestedStruct { inner, count }
    }

    // Function to test variable shadowing inside a while loop
    public fun variable_shadowing_test(): u64 {
        let counter: u64 = 0;
        let initial_value = counter;
        // Inside loop, shadow variable 'counter' with new variable
        while (counter < 5) {
            let counter = counter + 1; // shadowed 'counter'
            // check shadowed 'counter' value
            assert!(counter <= 5, 888);
        };
        // outside loop, original 'counter' should be unaffected
        initial_value + 5
    }

    // Function to test nested field access within control flow
    public fun nested_field_in_if(ns: &mut NestedStruct): u64 {
        if (ns.inner.b % 2 == 0) {
            // update nested fields and count
            ns.inner.b = ns.inner.b + 2;
            ns.count = ns.count + 3;
        } else {
            // nested access combined with variable assignment
            let new_b = ns.inner.b + 1;
            ns.inner.b = new_b;
        };
        ns.inner.b + ns.count
    }

    // Function with internal modifier to restrict access
    internal fun secret_internal_fn(val: u64): u64 {
        val * 2
    }

    // Function to verify internal function access (should be callable within module)
    public fun test_internal_access(): u64 {
        secret_internal_fn(21)
    }

    // External call to verify internal restriction; should be disallowed in tests
    // (We do not expose this outside, just highlighting scope restrictions)

    // Function to test specification annotations combined with nested access
    public fun spec_and_nested_access(ns: &mut NestedStruct): u64 has {
        ensures: ns.count >= 0,
    } {
        // nested dot access combined with specs
        ns.inner.a = ns.inner.a + 100;
        // call internal function within constraints
        update_count(ns);
        // assertion conditioned on spec invariants
        assert!(ns.inner.a >= 100, 777);
        ns.inner.a + ns.count
    }
}

//--- Test commands ---
// Use standard comments for CLI commands

// To run variable_shadowing_test:
// run 0xCAFE::InteractionTest::variable_shadowing_test

// To run process_struct_with_specs with args and signers:
// run 0xCAFE::InteractionTest::process_struct_with_specs --signers 0xBADD --args 5u64 10u64

// To run nested_field_in_if with signer:
// run 0xCAFE::InteractionTest::nested_field_in_if --signers 0xC0DE --args 0u64

// To test internal access function:
// run 0xCAFE::InteractionTest::test_internal_access
