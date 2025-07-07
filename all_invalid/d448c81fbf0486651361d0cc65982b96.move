
//# publish
module 0xC0FF::VisibilityTests {
    // This module tests function visibility (public, friend),
    // address annotations (with address markers),
    // and calling permissions across modules and accounts.

    use std::signer;

    // Public function
    public fun public_func(): u64 {
        42
    }

    // Friend function - only modules that are declared as friends
    // (simulate friend by making it pub(friend))
    // Note: Move currently doesn't have 'friend' keyword explicitly,
    // but for test purpose, we simulate with 'public' and access restrictions
    // By convention, treat functions as friend if only accessible within the module
    // but for testing, mark it as 'public' with a comment.
    // This is more of a test of not having 'friend' feature, so we'll just make it pub.
    // In real scenarios, access control is enforced by the move compiler's privacy.
    public fun friend_func(): u64 {
        7
    }

    // Function with address annotation (simulated via module address literal)
    public fun address_annotated_func(): u64 {
        100
    }
}

// External module from different address
//# publish
module 0xDEAD::ExternalCaller {
    use std::signer;

    // Function to call visibility functions in 0xC0FF module
    public fun call_public() {
        let result = 0xC0FF::VisibilityTests::public_func();
        // result is 42
        move(result);
    }

    public fun call_friend() {
        // The friend function is accessible if public
        let result = 0xC0FF::VisibilityTests::friend_func();
        move(result);
    }

    public fun call_address_annotation() {
        let result = 0xC0FF::VisibilityTests::address_annotated_func();
        move(result);
    }
}


//# run 0xC0FF::VisibilityTests::public_func

//# run 0xC0FF::VisibilityTests::friend_func

//# run 0xC0FF::VisibilityTests::address_annotated_func


//# run 0xDEAD::ExternalCaller::call_public --signers 0xBADD

//# run 0xDEAD::ExternalCaller::call_friend --signers 0xBADD

//# run 0xDEAD::ExternalCaller::call_address_annotation --signers 0xBADD

//-----------------------------------------------------------------
// Additional testing functions with conditional expressions and address usage

//# publish
module 0xBEEF::ConditionalFlows {
    // Functions testing '||' in 'if' conditions and combined logic

    public fun check_conditions(x: u8, y: u8): bool {
        if (x > 5 || y < 3) {
            true
        } else {
            false
        }
    }

    // Function with combined 'if' and '||' with address parameters
    public fun address_conditional_call(signer_addr: address, flag: bool): u64 {
        if ((signer_addr == @0xCAFE) || flag) {
            1
        } else {
            0
        }
    }
}

// Test scripts invoking functions with '||' and address references


//# run 0xBEEF::ConditionalFlows::check_conditions --args 6 4

//# run 0xBEEF::ConditionalFlows::check_conditions --args 4 2

//# run 0xBEEF::ConditionalFlows::address_conditional_call --signers 0xCAFE --args true

//# run 0xBEEF::ConditionalFlows::address_conditional_call --signers 0xBADD --args false

//-----------------------------------------------------------------
// Combined tests for layered access, address resolution, and conditionals

//# publish
module 0xFACE::IntegratedTests {
    use 0xC0FF::VisibilityTests;
    use 0xBEEF::ConditionalFlows;

    // Wrapper functions to test calling across modules and address conditions
    public fun run_public_tests() {
        // Call public functions from external to this module
        let val1 = VisibilityTests::public_func();
        move(val1);
        // Call friend functions
        let val2 = VisibilityTests::friend_func();
        move(val2);
    }

    public fun run_conditional_address_test(signer_addr: address, flag: bool): u64 {
        // call the conditional address function from another module
        let result = ConditionalFlows::address_conditional_call(signer_addr, flag);
        move(result);
    }

    // Function to test combined control flow with multiple conditions
    public fun combined_flow_test(x: u8, y: u8, addr: address, flag: bool): u64 {
        if (VisibilityTests::public_func() > 40 || ConditionalFlows::check_conditions(x, y)) {
            if (addr == @0xCAFE || flag) {
                999
            } else {
                0
            }
        } else {
            777
        }
    }
}


//# run 0xFACE::IntegratedTests::run_public_tests

//# run 0xFACE::IntegratedTests::run_conditional_address_test --signers 0xCAFE --args true

//# run 0xFACE::IntegratedTests::combined_flow_test --args 7 2 0xCAFE true


// Featurres:
// 03b151a72fa5a91acd9ab793b789d8e8: Define public or friend visible functions inside a module.
// cdcdafb2e2568672a036eadd1b1179b2: Use address specifier 'Literal' to specify a concrete address directly.
// f47e3ac072a9d0101196516a25a944d4: Use '||' to create multiple alternatives, if supported.
