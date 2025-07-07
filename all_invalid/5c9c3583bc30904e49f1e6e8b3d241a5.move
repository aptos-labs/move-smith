//# publish
module 0xCAFE::VectorRemoveTest {
    use std::vector;
    use std::signer;
    use 0xCAFE::MyModule;

    #[skip(only_readability)]
    struct Item has copy, drop, store {
        id: u8,   // Field to match against
        value: u64,
    }

    struct Container has store {
        items: vector<Item>,
    }

    public fun new_container(): Container {
        let items = vector[
            Item {id: 1, value: 100},
            Item {id: 2, value: 200},
            Item {id: 3, value: 300},
        ];
        Container { items }
    }

    public fun find_and_remove(c: &mut Container, target_id: u8): bool {
        let len = vector::length(&c.items);
        let mut i = 0;
        let mut found = false;
        while (i < len) {
            let item_ref = vector::borrow(&c.items, i);
            if (item_ref.id == target_id) {
                let _removed = vector::swap_remove(&mut c.items, i);
                found = true;
                break;
            };
            i = i + 1;
        };
        found
    }

    public fun test_remove_found(): bool {
        let mut c = new_container();
        let found_before = find_and_remove(&mut c, 2);
        // Attempt to find again should fail since removed
        let found_after = find_and_remove(&mut c, 2);
        found_before && !found_after
    }

    public fun test_remove_not_found(): bool {
        let mut c = new_container();
        // Remove non-existing id
        !find_and_remove(&mut c, 99)
    }

    public fun runner(): bool {
        let found_test = test_remove_found();
        let not_found_test = test_remove_not_found();
        found_test && not_found_test
    }
}

//# run 0xCAFE::VectorRemoveTest::runner

// Featurres:
// 28b2d9c9fe27a9260a6199bf06ea3bcb: Test that you can find and remove an element from a vector in a struct by matching a field using a predicate, and properly handle both matching and non-matching cases.
// a99471d2ea89cf76f0ccd0486eb6abcd: Configure your code with `#[skip(lint_name)]` attributes to customize lint enforcement according to your preferences.
// e6f30b85424e139c306d6bec24378617: Refer to Move modules either by their named address or by their numerical (hex) address in module identifiers.
