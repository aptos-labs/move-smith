
//# publish
module 0xDEAD::CapabilityEnforcement {
    use std::signer;
    use std::vector;

    struct ResourceA has key, store {
        value: u64,
    }

    // Public function to create and store ResourceA; should be accessible publicly.
    public fun create_resource(s: signer, val: u64) {
        let resource = ResourceA { value: val };
        move_to<ResourceA>(&s, resource);
    }

    // Private function attempting to access ResourceA: access control examination.
    fun get_resource_value(s: &signer): u64 acquires ResourceA {
        let resource_ref: &ResourceA = borrow_global<ResourceA>(signer::address_of(s));
        resource_ref.value
    }

    // Public wrapper for private function that attempts to access resource
    public fun retrieve_resource_value(s: &signer): u64 {
        get_resource_value(s)
    }

    // Function with spec block: verify read restriction is enforced during condition check.
    fun function_with_spec(s: signer): u64 acquires ResourceA {
        // Spec block with condition
        spec {
            // This condition should be verified during verification
            Condition {
                is(ResourceA): {
                    // Access the resource (simulate a read condition)
                    let res_ref = borrow_global<ResourceA>(signer::address_of(&s));
                    res_ref.value > 0
                }
            }
        };

        // Actual function logic: accessing resource
        let resource_value = get_resource_value(&s);
        resource_value
    }

    // Test that access to resource outside permitted functions triggers enforcement
    public fun attempt_unauthorized_access(s: signer): u64 acquires ResourceA {
        // Directly borrow global resource (should be flagged if access control enforces restrictions)
        let res_ref: &ResourceA = borrow_global<ResourceA>(signer::address_of(&s));
        res_ref.value
    }

    // Function illustrating conditions and warnings for AST-level analysis
    public fun warn_on_expression(s: signer): u64 {
        spec {
            Condition {
                is(ResourceA): {
                    // Intentionally complex expression for warning
                    let value_ref = borrow_global<ResourceA>(signer::address_of(&s));
                    let v1 = value_ref.value;
                    let v2 = v1 + 0; // no-op addition
                    v2 > 0
                }
            }
        };

        // Real function logic
        let val = get_resource_value(&s);
        val
    }
}


//# run 0xDEAD::CapabilityEnforcement::create_resource --signers 0xBADD --args 42u64


//# run 0xDEAD::CapabilityEnforcement::retrieve_resource_value --signers 0xBADD


//# run 0xDEAD::CapabilityEnforcement::function_with_spec --signers 0xBADD


//# run 0xDEAD::CapabilityEnforcement::attempt_unauthorized_access --signers 0xBADD


//# run 0xDEAD::CapabilityEnforcement::warn_on_expression --signers 0xBADD


// Featurres:
// 7c1d99aad727aee08a66a4873aae3d23: Test that negative ability constraints like !reads on function visibility modifiers are properly enforced and interpreted when accessing resources with borrow_global.
// 096995bf2c4c8caed00d42a8669cb5a5: Define specification condition expressions within spec blocks using 'Condition' with an expression and optional additional expressions.
// d70e81f17404f3104f1fc0d856d22c9c: Receive context, AST, and bytecode level warnings and errors for enhanced code feedback.
