
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
        public fun create_resource(owner: &signer, initial_balance: u64) {
            assert!(initial_balance >= 0, 1);
            move_to(owner, MyResource { balance: initial_balance as i64 });
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


//# run 0xCAFE::InvariantModule::create_resource --signers 0xAABB --args 100u64



//# run 0xCAFE::InvariantModule::test_abort_behavior --signers 0xAABB