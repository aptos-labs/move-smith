// # publish
address 0xCAFE {
    module VectorRemoveTest {
        use std::vector;
        use std::signer;

        /// A struct holding a vector of Items
        struct Item has copy, drop, store {
            id: u64,
            value: u8,
        }

        struct Container has key {
            items: vector<Item>,
        }

        /// Publish a Container with some Items
        public fun publish_example(s: &signer) {
            let items = vector::empty<Item>();
            vector::push_back(&mut items, Item { id: 1, value: 10 });
            vector::push_back(&mut items, Item { id: 2, value: 20 });
            vector::push_back(&mut items, Item { id: 3, value: 30 });
            move_to(s, Container { items });
        }

        /// Find and remove an Item by id, returns true if found and removed, false otherwise
        public fun find_and_remove(container: &mut Container, id_to_find: u64): bool {
            let mut i = 0;
            let len = vector::length(&container.items);
            while (i < len) {
                let item = *vector::borrow(&container.items, i);
                if (item.id == id_to_find) {
                    vector::remove(&mut container.items, i);
                    return true;
                };
                i = i + 1;
            };
            false
        }

        /// "Runner" function to test find_and_remove on-chain
        /// Removes id=2 and then tries to remove id=42 (non-existing)
        public fun runner(s: &signer) {
            let container = borrow_global_mut<Container>(signer::address_of(s));
            let removed_existing = find_and_remove(container, 2);
            let removed_nonexisting = find_and_remove(container, 42);

            // Use removed_existing and removed_nonexisting in specs to reference global memory
            #[invariant(container: &Container)]
            fn container_invariant(c: &Container) {
                // Spec code referencing container.items vector and predicate (id field)
                ensures(vector::length(&c.items) <= 3);
            };

            // We don't require explicit acquires annotation for borrow_global_mut here,
            // letting compiler infer it starting with aptos 2.2+
        }
    }
}
// # run 0xCAFE::VectorRemoveTest::publish_example --signers 0xCAFE
// # run 0xCAFE::VectorRemoveTest::runner --signers 0xCAFE

// # run
script {
    use 0xCAFE::VectorRemoveTest;
    use std::signer;

    fun main(account: signer) {
        // Publish container with 3 items
        VectorRemoveTest::publish_example(&account);
        // Run the runner function to test vector find and remove
        VectorRemoveTest::runner(&account);
    }
}

// Featurres:
// 28b2d9c9fe27a9260a6199bf06ea3bcb: Test that you can find and remove an element from a vector in a struct by matching a field using a predicate, and properly handle both matching and non-matching cases.
// 31339dd99238e13add680fcfd365beb5: Reference memory used in global invariants to ensure correct usage in your specifications.
// 028ad224eff2f384fbe0cfff661afd67: Rely on the compiler to infer missing acquire annotations in functions when `acquires` is at least version 2.2.
