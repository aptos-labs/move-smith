//# publish
module 0xCAFE::VerificationTest {
    use std::signer;
    use std::option;

    // A resource that requires key and store abilities for verification testing
    struct VerRes has key, store {
        val: u8,
    }

    // Verification attribute for an opaque spec function requiring specific properties
    #[verifier(spec)]
    spec fun always_true(_x: u8): bool {
        true
    }

    #[verifier(spec)]
    #[verifier(verbatim)]
    spec fun is_even(x: u8): bool {
        x % 2u8 == 0u8
    }

    // A function marked with verification attribute to require certain conditions hold
    #[verifier(test)]
    public fun verified_function(x: u8): u8 {
        // Local variable initialization checks can be manually verified by VM
        let a = x + 1u8;
        let b = a * 2u8;
        let _ = if (b > 10u8) {
            b
        } else {
            a
        };
        b
    }

    // Public function that stores a VerRes resource to test resource initialization and verification
    public fun create_resource(s: &signer, value: u8) {
        let vr = VerRes { val: value };
        move_to<VerRes>(s, vr);
    }

    // Function that branches conditionally and returns different values accordingly,
    // exercising conditional branch bytecode execution
    public fun conditional_branch(x: u8): u8 {
        if (x < 5u8) {
            100u8
        } else {
            200u8
        }
    }

    // Function purposely demonstrating uninitialized local analysis by breaking normal patterns
    public fun uninitialized_locals_flow(x: u8) {
        let a = 0u8;
        if (x > 0u8) {
            let _b = x;
            // 'c' is uninitialized here, but function ends before usage 
        } else {
            // do nothing here;
        };
        // 'a' is initialized and used here for verification state
        let _ = a + 1u8;
    }

    // Runner function that calls all the above to force their inclusion in verification/tests
    public fun runner(s: &signer) {
        let _ = verified_function(7u8);
        create_resource(s, 42u8);
        let _ = conditional_branch(3u8);
        let _ = conditional_branch(8u8);
        uninitialized_locals_flow(1u8);
        uninitialized_locals_flow(0u8);
    }
}

//# run 0xCAFE::VerificationTest::verified_function --args 9u8

//# run 0xCAFE::VerificationTest::conditional_branch --args 2u8

//# run 0xCAFE::VerificationTest::conditional_branch --args 8u8

//# run 0xCAFE::VerificationTest::create_resource --signers 0xBA5E --args 55u8

//# run 0xCAFE::VerificationTest::uninitialized_locals_flow --args 3u8

//# run 0xCAFE::VerificationTest::runner --signers 0xBA5E