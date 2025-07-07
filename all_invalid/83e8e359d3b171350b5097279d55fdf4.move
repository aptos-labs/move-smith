
//# publish
module 0xBADD::TestModule {
    // Basic structure to hold dependency graph info
    use std::signer;
    use std::vector;

    // Enum to test include with properties in specs
    enum PropertyEnum has copy, drop {
        Label(u8),
        Details(string),
    }

    // Struct to test transformation of PackagePaths name from String to Symbol
    struct PackagePath has key, store {
        address: address,
        name: vector<u8>,
        // Instead of storing a String, we simulate a Symbol with just a vector of u8
    }

    // Function to create a package path with string name
    public fun create_package_path(addr: address, name_str: vector<u8>): PackagePath {
        PackagePath { address: addr, name: name_str }
    }

    // Function to test include in spec properties
    public fun include_property_test(flag: bool): bool {
        if (flag) {
            // Include a property with label
            let _prop = PropertyEnum::Label(1);
        } else {
            // Include a property with details
            let _prop = PropertyEnum::Details(b"example");
        };
        // Return true if include is successful
        true
    }

    // Function to simulate detection of cycle in dependency graph
    // Using adjacency list representation
    // Graph is represented as vector of vectors
    // Using node ids (u8) for simplicity
    public fun detect_cycle_in_graph(edges: vector<vector<u8>>): bool {
        // Initialize visited set
        let visited = vector::empty<bool>();
        let size = vector::length(&edges);
        vector::resize(&mut visited, size, false);

        // Function to check cycle starting from node
        public fun dfs(node: u8, parent: u8): bool {
            vector::borrow_mut(&mut visited, node as usize) = true;

            let neighbors = vector::borrow(&edges, node as usize);
            let n = vector::length(neighbors);
            let i = 0;
            while (i < n) {
                let neighbor = *vector::borrow(&neighbors, i);
                // Check if not visited
                if (!*vector::borrow(&visited, neighbor as usize)) {
                    if (dfs(neighbor, node)) {
                        return true;
                    };
                } else if (neighbor != parent) {
                    // Cyclic dependency found
                    return true;
                };
                i = i + 1;
            };
            false
        }

        // Check for cycle starting from node 0 (arbitrary node)
        // To simulate a cycle detection involving a specific node, assume node 0 is in cycle
        // For test, define edges such that there's a cycle involving node 0
        // e.g., edges: 0 -> 1, 1 -> 2, 2 -> 0
        // Setup for test
        let test_edges = vector::empty<vector<u8>>();
        vector::push_back(&mut test_edges, vector::empty<u8>()); // node 0
        vector::push_back(&mut test_edges, vector::empty<u8>()); // node 1
        vector::push_back(&mut test_edges, vector::empty<u8>()); // node 2

        // Populate edges for cycle
        // For simplicity, assign edges directly
        {
            // For node 0
            let neighbors_0 = vector::empty<u8>();
            vector::push_back(&mut neighbors_0, 1);
            vector::push_back(&mut test_edges, neighbors_0);
        }
        {
            // For node 1
            let neighbors_1 = vector::empty<u8>();
            vector::push_back(&mut neighbors_1, 2);
            vector::push_back(&mut test_edges, neighbors_1);
        }
        {
            // For node 2
            let neighbors_2 = vector::empty<u8>();
            vector::push_back(&mut neighbors_2, 0);
            vector::push_back(&mut test_edges, neighbors_2);
        };

        // Run cycle detection
        dfs(0, 255) // pass invalid parent for root as 255
    }
}


//# run 0xBADD::TestModule::include_property_test --args true


//# run 0xBADD::TestModule::detect_cycle_in_graph --args [vector![1u8,2u8], vector![2u8], vector![0u8]] --signers 0xBADD


// Featurres:
// 6e0da44f71576c1f38f66496810c4af8: Include other specifications or specification expressions with properties via include in spec blocks.
// 1de156acf4761c997a26d72aab4925a3: Transform the 'name' field of a PackagePaths from String to Symbol.
// a10b1051a24cb0f4089ba64928937a8b: Identify a cycle in the dependency graph involving a specific starting node.
