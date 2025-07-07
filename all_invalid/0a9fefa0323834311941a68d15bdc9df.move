// transactional_test.move

address 0x1 {
module TestModule {
    use std::debug;
    use std::signer;

    /// A deprecated struct to test warnings about deprecated items.
    #[deprecated(msg = "OldStruct is deprecated, use NewStruct instead", code = 1234)]
    struct OldStruct has copy, drop, store {
        val: u8,
    }

    /// A new struct to replace deprecated one.
    struct NewStruct has copy, drop, store {
        val: u8,
    }

    /// A function that triggers use of deprecated item.
    public fun use_deprecated(addr: address) {
        let _old = OldStruct { val: 10 };
        debug::print(&b"Using deprecated struct."_); // Just a dummy usage
    }

    /// A function to test axiom with expression condition.
    /// We add an axiom that the sum is always >= 0
    /// Using address literal 0x1 explicitly.
    public fun check_sum(a: u64, b: u64) acquires OldStruct {
        let sum = a + b;

        // Axiom with an expression as the condition content
        axiom sum >= 0;

        // Use deprecated item intentionally to get compiler diagnostics
        let _deprecated_val = OldStruct { val: 5 };

        // Use address literal explicitly in a condition
        let addr_specifier: address = 0x1;

        // Notify use of addr_specifier to avoid unused warning
        assert!(addr_specifier == 0x1, 1);
    }
}
}

// Transactional test code
script {
    use 0x1::TestModule;

    fun main() {
        // Testing deprecated struct usage notification
        TestModule::use_deprecated(0x1);

        // Testing axiom with expressions, and literal address specifier
        TestModule::check_sum(10, 20);
    }
}

// Featurres:
// 85f1d0e6276502413d63a06cb6fd2c4e: Add an expression as the condition's content within the 'axiom'.
// e133b83e8cfd6f30e533670f929994bc: Specify literal addresses as address specifiers.
// b2081e928f636305e3be6e682bcc0741: Get notifications about the use of deprecated items with specific diagnostic codes.
