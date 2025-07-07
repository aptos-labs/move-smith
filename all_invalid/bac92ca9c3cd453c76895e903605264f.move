
//# publish
address 0xCAFE {
    module InvariantModule {
        use move::vector;
        use move::errors;
        use move::global_invariants;

        /// Define a resource with an invariant that balances must be zero
        struct MyResource has key {
            balance: i64,
        }

        /// Initialize the resource under a global invariant
        public fun create_resource(owner: &signer, initial_balance: i64) {
            assert!(initial_balance >= 0, 1);
            move_to(owner, MyResource { balance: initial_balance });
        }

        // Global invariant: balance must always be >= 0
        global_invariants! {
            invariant invariant_balance_non_negative {
                // Access the resource stored at the given address (owner)
                predicate "balance >= 0" (resource: &MyResource) {
                    resource.balance >= 0
                }
            }
        }

        /// Function that attempts to modify the resource balance, possibly aborting
        public fun test_abort_behavior(owner: &signer) {
            let resource_ref = borrow_global_mut<MyResource>(move!(owner));
            // Intentionally cause an invariant violation
            let current_balance = resource_ref.balance;
            // abort with a specific code
            if current_balance < 10 {
                abort(42);
            }
            resource_ref.balance = current_balance - 10;
        }
    }
}


//# run
// Call create_resource to set up the resource

//# run 0xCAFE::InvariantModule::create_resource --signers 0xAABB --args 100i64


//# run 0xCAFE::InvariantModule::test_abort_behavior --signers 0xAABB

// Featurres:
// 0d819c688c655b41ba48a5bae7e0ea36: Use explicit address name syntax for defining addresses.
// 11cd210cb22875e7781aba2a76b1f857: Define global invariants in your Move modules using specification conditions with the GlobalInvariant or GlobalInvariantUpdate kinds.
// 495c054e8bb1e34a7a3807d4b0278743: Abort execution with the `abort` expression, providing a value.
