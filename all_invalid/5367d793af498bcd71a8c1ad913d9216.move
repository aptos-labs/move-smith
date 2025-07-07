// transactional_test.move

module 0x1::TransactionalTest {

    use std::signer;
    use std::debug;

    /// A simple struct with nested fields to test dotted expressions
    struct Inner has copy, drop, store {
        val: u64,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
    }

    #[deprecated(reason = "Use new_function instead")]
    public fun deprecated_function(s: &signer) {
        debug::print(&"Deprecated function called!");
    }

    #[test_only]
    #[assert_only]
    public fun new_function(s: &signer) {
        // Test terminate expressions with various tokens:

        // Expression terminated with comma
        let x = 10u64;

        // Expression terminated with semicolon
        let y = 20u64;

        // Expression terminated with colon in struct initialization
        let inner = Inner { val: x };

        // Expression terminated with }
        let outer = Outer { inner };

        // Use dotted expressions to access nested fields
        let inner_val: u64 = outer.inner.val;

        // Conditional terminated by else
        let message = if (inner_val == x) {
            "Values match"
        } else {
            "Values do not match"
        };

        // Print the message
        debug::print(&message);

        // Expressions terminated by )
        let sum = inner_val.checked_add(y);
        if (sum.is_some()) {
            debug::print(&"Sum is valid");
        } else {
            debug::print(&"Sum overflowed");
        };
    }

    #[test]
    public fun test_all_features(s: &signer) {
        // Call deprecated function to test attribute
        deprecated_function(s);

        // Call new function
        new_function(s);

        // Also test terminating commas in vector creation (use vector feature)
        let v = vector::empty<u64>();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);
        vector::push_back(&mut v, 3);

        // Test dotted expression on vector length
        let len: u64 = vector::length(&v);

        // Test terminating with semicolon and colon in tuple destructuring
        let (first, second, third) = (v[0], v[1], v[2]);

        debug::print(&("Vector length: "));
        debug::print(&len);

        debug::print(&("First element: "));
        debug::print(&first);

        debug::print(&("Second element: "));
        debug::print(&second);

        debug::print(&("Third element: "));
        debug::print(&third);
    }
}

// Featurres:
// f900b94dca53be25721b14907d8740c3: Terminate expressions with tokens such as else, }, ), ,, :, or ; to indicate the end of an expression in your Move code.
// a5c4bcfe72a96ce9ac6d7199f8fab616: Annotate functions with deprecated or other metadata attributes for conditional behavior.
// caa57bfd6e04ab56caa49079470d78af: Use dotted expressions to access nested fields or members in Move code.
