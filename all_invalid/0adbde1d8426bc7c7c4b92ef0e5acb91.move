//# publish
address 0xCAFE {
    module StringList {
        // Define a resource to store list of vectors
        struct List {
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