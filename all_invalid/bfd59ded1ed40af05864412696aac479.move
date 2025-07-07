//# publish
address 0xCAFE {
    module StringList {
        // Define a resource to store list of vectors
        resource struct List {
            items: vector<vector<u8>>,
        }

        // Initialize an empty list resource under an address
        public fun init_list(account: &signer) {
            move_to(account, List { items: vector::empty() });
        }

        // Append a new item to the list
        public fun append_item(account: &signer, item: vector<u8>) {
            let list_ref = borrow_global_mut<List>(Signer::address_of(account));
            vector::push_back(&mut list_ref.items, item);
        }

        // Parse raw bytes into list of vectors (simulate parsing empty list)
        public fun parse_empty_list() {
            let empty_list = vector::empty();

            // Create a List resource with an empty vector
            let parsed_list = List { items: empty_list };

            // Return the parsed list (not storing it globally, just for test)
            move(move parsed_list);
        }

        // Example runner function to test parsing of empty list
        public fun run_parse_empty() {
            parse_empty_list();
        }
    }
}

//# run 0xCAFE::StringList::run_parse_empty

// Featurres:
// 7ce9e0b31dcb635a99efad8f920a0af4: Define address blocks that group one or more modules under a named address.
// 7282f71ab15dd29def3d23bb4a2e2dad: Allow parsing of empty lists when the end token immediately follows the start.
// a6e10024aa543c46926e5bc7a36747d7: Rely on the compiler to mark spec functions containing imperative expressions as uninterpreted, so they are excluded from certain verification analyses.
