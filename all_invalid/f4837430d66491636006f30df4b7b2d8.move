
//# publish
module 0xCAFE::FeatureInteractionTest {
    use std::vector;

    // Function to test unreachable code with address references and shadowing inside unreachable block
    public fun test_unreachable_code_with_shadowing(addr_ref: address): u64 {
        let result = 0u64;

        // Unreachable code block: should be recognized as unreachable by compiler
        if (false) {
            // Address reference using a named address
            let target_addr = 0xPROJECT::SomeModule::SOME_CONSTANT;

            // Shadowing variable 'x'
            let x = 42u64;
            // Shadowing again inside nested scope
            {
                let x = 999u64; // This shadows the outer 'x'
                result = x; // Should be 999
            }
            result = target_addr; // Will not be executed
        };

        // Active code after unreachable block
        let final_x = 7u64;
        // Shadowing in accessible scope
        let final_x = final_x + 1;
        result = final_x; // Should be 8

        result
    }

    // Function to demonstrate strong address referencing (resolution of named addresses)
    public fun address_resolution_test(): address {
        // Using a named address (assuming project address is 0xPROJECT)
        let addr: address = 0xPROJECT::SomeModule::SOME_CONSTANT;
        addr
    }

    // Function to test variable shadowing resolution
    public fun shadowing_demo(): u64 {
        let x = 10u64;
        {
            let x = 20u64; // inner scope shadowing
            let _ = x; // shadowed x == 20
        };
        // after inner scope, 'x' should be 10
        // Shadow again with different value
        let x = 30u64; // outer shadow
        x // return value should be 30
    }

    // Function combining all tests: unreachable code, address references, shadowing
    public fun combined_feature_test(addr_ref: address): u64 {
        // Starting with visible value
        let val = 0u64;

        if (false) {
            // Inside unreachable block

            // Use address reference (assuming address is resolved correctly)
            let _addr_resolved = 0xPROJECT::OtherModule::CONSTANT;
            // Shadow variable 'x'
            let x = 55u64;
            {
                let x = 999u64; // shadow inner
            }
            // Final assignment (unreachable)
            val = 1111;
        };

        // Shadowing in active scope
        let val = val + 4;

        // Shadow in outer visible scope
        let val = val + 2;

        val // Should be 6
    }
}


//# run 0xCAFE::FeatureInteractionTest::test_unreachable_code_with_shadowing --args 0x1234u64


//# run 0xCAFE::FeatureInteractionTest::address_resolution_test


//# run 0xCAFE::FeatureInteractionTest::shadowing_demo


//# run 0xCAFE::FeatureInteractionTest::combined_feature_test --args 0x5555u64


// Featurres:
// 0f969730f1ad33e58b8fdc7180c14a97: Use 'no' as an indication that a code segment is definitely not reachable.
// 738bbd0c05537d4ac69d60f7ca987527: Reference named addresses from the project-specific address mapping.
// 2c1617f9e58b389334637b87806709af: Test that let variable names can be shadowed within the same function and correctly yield the final assigned value.
