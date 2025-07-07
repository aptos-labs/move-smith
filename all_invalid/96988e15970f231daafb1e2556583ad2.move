
//# publish
module 0xCAFE::DependencyGraph {
    use std::string;
    use std::vector;
    use std::signer;

    // A simple Node struct representing a module node in the graph
    public struct Node has copy, drop, store {
        name: vector<u8>,
        dependencies: vector<vector<u8>>, // vector of module names
    }

    // The graph as a vector of nodes, stored in an app resource
    public struct Graph has store {
        nodes: vector<Node>,
    }

    // Initialize the graph resource at address if not exists
    public fun init_graph(addr: &signer) {
        if (!exists<Graph>(signer::address_of(addr))) {
            move_to<Graph>(addr, Graph { nodes: vector[] });
        };
    }

    // Add a module node with dependencies (can be empty)
    public fun add_node(addr: &signer, name: vector<u8>, dependencies: vector<vector<u8>>) {
        let graph = borrow_global_mut<Graph>(signer::address_of(addr));
        let node = Node { name, dependencies };
        vector::push_back(&mut graph.nodes, node);
    }

    // Check if node present by name (returns index or Option::none)
    public fun find_node(addr: &signer, name: &vector<u8>): option::Option<u64> {
        let graph = borrow_global<Graph>(signer::address_of(addr));
        let len = vector::length(&graph.nodes);
        let i = 0u64;
        while (i < len) {
            let node_ref = &vector::borrow(&graph.nodes, i);
            if (string::utf8_equal(&node_ref.name, name)) {
                return option::some(i);
            };
            i = i + 1;
        };
        option::none()
    }

    // Get node count
    public fun node_count(addr: &signer): u64 {
        let graph = borrow_global<Graph>(signer::address_of(addr));
        vector::length(&graph.nodes) as u64
    }
}



//# run 0xCAFE::DependencyGraph::init_graph --signers 0xDB01



//# run 0xCAFE::DependencyGraph::add_node --signers 0xDB01 --args b"ModuleA" vector[]


/*
  Add a module node with no dependencies. This tests adding module nodes standalone.
*/



//# run 0xCAFE::DependencyGraph::add_node --signers 0xDB01 --args b"ModuleB" vector[b"ModuleA"] 


/*
  Add a module node with one dependency (ModuleA). This tests adding dependent modules.
*/



//# run 0xCAFE::DependencyGraph::find_node --signers 0xDB01 --args b"ModuleA"



//# run 0xCAFE::DependencyGraph::node_count --signers 0xDB01



//# publish
module 0xCAFE::MapOperations {
    use std::string;
    use std::option;
    use std::vector;
    use std::signer;

    /// A simple key-value store where keys are vector<u8> (strings),
    /// values are u64 counters representing counts/values

    public struct KVMap has store {
        keys: vector<vector<u8>>,
        values: vector<u64>,
    }

    public fun init_map(addr: &signer) {
        if (!exists<KVMap>(signer::address_of(addr))) {
            move_to<KVMap>(addr, KVMap {
                keys: vector[],
                values: vector[],
            });
        };
    }

    public fun find_key_idx(map: &KVMap, key: &vector<u8>): option::Option<u64> {
        let len = vector::length(&map.keys);
        let i = 0u64;
        while (i < len) {
            let k = vector::borrow(&map.keys, i);
            if (string::utf8_equal(k, key)) {
                return option::some(i);
            };
            i = i + 1;
        };
        option::none()
    }

    public fun insert_or_increment(addr: &signer, key: vector<u8>) {
        let map = borrow_global_mut<KVMap>(signer::address_of(addr));
        let idx_opt = find_key_idx(&map, &key);
        match idx_opt {
            option::Option::some(i) => {
                let val_ref = vector::borrow_mut(&mut map.values, i);
                *val_ref = *val_ref + 1;
            },
            option::Option::none() => {
                vector::push_back(&mut map.keys, key);
                vector::push_back(&mut map.values, 1u64);
            },
        };
    }

    // Retrieve the current value of a key, or 0 if not found
    public fun get_value(addr: &signer, key: vector<u8>): u64 {
        let map = borrow_global<KVMap>(signer::address_of(addr));
        let idx_opt = find_key_idx(&map, &key);
        match idx_opt {
            option::Option::some(i) => *vector::borrow(&map.values, i),
            option::Option::none() => 0u64,
        }
    }
}



//# run 0xCAFE::MapOperations::init_map --signers 0xDEAD



//# run 0xCAFE::MapOperations::insert_or_increment --signers 0xDEAD --args b"key1"



//# run 0xCAFE::MapOperations::get_value --signers 0xDEAD --args b"key1"



//# run 0xCAFE::MapOperations::insert_or_increment --signers 0xDEAD --args b"key1"



//# run 0xCAFE::MapOperations::get_value --signers 0xDEAD --args b"key1"



//# run 0xCAFE::MapOperations::insert_or_increment --signers 0xDEAD --args b"key2"



//# run 0xCAFE::MapOperations::get_value --signers 0xDEAD --args b"key2"



//# publish
module 0xCAFE::CombinedTest {
    use std::string;
    use std::vector;
    use std::signer;
    use std::option;

    use 0xCAFE::DependencyGraph;
    use 0xCAFE::MapOperations;

    // This function adds a node to the dependency graph and
    // increments count entry in the map using the node name as key.
    public fun add_node_and_update_map(s: signer, name: vector<u8>, dependencies: vector<vector<u8>>) {
        DependencyGraph::add_node(&s, name, dependencies);
        MapOperations::insert_or_increment(&s, name);
    }

    // Runner with no args for testing adding a node with no dependency but updates map.
    public fun runner_simple(s: signer) {
        let name = b"StandaloneNode";
        let deps = vector[];
        add_node_and_update_map(s, name, deps);
    }

    // Runner with a node that has dependencies and updates map accordingly.
    public fun runner_with_dependency(s: signer) {
        let name = b"NodeWithDeps";
        let deps = vector[b"StandaloneNode"];
        add_node_and_update_map(s, name, deps);
    }
}



//# run 0xCAFE::CombinedTest::runner_simple --signers 0xB0B0



//# run 0xCAFE::CombinedTest::runner_with_dependency --signers 0xB0B0



//# run 0xCAFE::MapOperations::get_value --signers 0xB0B0 --args b"StandaloneNode"



//# run 0xCAFE::MapOperations::get_value --signers 0xB0B0 --args b"NodeWithDeps"



//# publish
module 0xCAFE::FormatState {
    use std::string;
    use std::vector;
    use std::option;
    use std::signer;

    use 0xCAFE::DependencyGraph;
    use 0xCAFE::MapOperations;

    // Return a string describing the graph nodes and their dependencies
    public fun format_graph(addr: &signer): vector<u8> {
        let graph = borrow_global<DependencyGraph::Graph>(signer::address_of(addr));
        let len = vector::length(&graph.nodes);
        let i = 0u64;
        let result = string::utf8(b"Graph State:\n");

        while (i < len) {
            let node = &vector::borrow(&graph.nodes, i);
            result = string::concat(&result, &string::utf8(b"Node: "));
            result = string::concat(&result, &node.name);
            result = string::concat(&result, &string::utf8(b", Deps: ["));
            let dep_len = vector::length(&node.dependencies);
            let j = 0u64;
            while (j < dep_len) {
                let dep = &vector::borrow(&node.dependencies, j);
                result = string::concat(&result, dep);
                if (j + 1 < dep_len) {
                    result = string::concat(&result, &string::utf8(b", "));
                };
                j = j + 1;
            };
            result = string::concat(&result, &string::utf8(b"]\n"));
            i = i + 1;
        };

        result
    }

    // Return a string describing the map keys and values
    public fun format_map(addr: &signer): vector<u8> {
        let map = borrow_global<MapOperations::KVMap>(signer::address_of(addr));
        let len = vector::length(&map.keys);
        let i = 0u64;
        let result = string::utf8(b"Map State:\n");
        while (i < len) {
            let key = &vector::borrow(&map.keys, i);
            let val = *vector::borrow(&map.values, i);
            result = string::concat(&result, key);
            result = string::concat(&result, &string::utf8(b" => "));
            result = string::concat(&result, &string::utf8(u64_to_ascii_vec(val)));
            result = string::concat(&result, &string::utf8(b"\n"));
            i = i + 1;
        };
        result
    }

    // Helper function to convert u64 to ASCII vector<u8>
    fun u64_to_ascii_vec(val: u64): vector<u8> {
        if (val == 0) {
            return vector[48u8]; // ASCII '0'
        };

        let v = vector[];
        let n = val;
        while (n > 0) {
            let d = (n % 10) as u8;
            vector::push_back(&mut v, 48u8 + d);
            n = n / 10;
        };
        vector::reverse(&mut v);
        v
    }

    /*
    Format the initialized state info before/after a given code offset.

    - If before_offset == true: output nodes and map entries *with* "offset" < 50 (mock condition)
    - If before_offset == false: output nodes and map entries with "offset" >= 50 (mock condition)
    (Offsets are mocked as hash of node name or map key length * 10)

    This is a mock example since we do not have real offsets.
    */
    public fun format_state_with_offset(addr: &signer, before_offset: bool): vector<u8> {
        let graph = borrow_global<DependencyGraph::Graph>(signer::address_of(addr));
        let map = borrow_global<MapOperations::KVMap>(signer::address_of(addr));

        let result = string::utf8(b"State filtered by offset:\nNodes:\n");

        let node_len = vector::length(&graph.nodes);
        let i = 0u64;
        while (i < node_len) {
            let node = &vector::borrow(&graph.nodes, i);
            // Mock offset: length of node name * 10
            let offset = (vector::length(&node.name) as u64) * 10;
            if (before_offset && offset < 50) || (!before_offset && offset >= 50) {
                result = string::concat(&result, &node.name);
                result = string::concat(&result, &string::utf8(b"\n"));
            };
            i = i + 1;
        };

        result = string::concat(&result, &string::utf8(b"Map entries:\n"));
        let map_len = vector::length(&map.keys);
        let j = 0u64;
        while (j < map_len) {
            let key = &vector::borrow(&map.keys, j);
            let offset = (vector::length(key) as u64) * 10;
            if (before_offset && offset < 50) || (!before_offset && offset >= 50) {
                result = string::concat(&result, key);
                result = string::concat(&result, &string::utf8(b"\n"));
            };
            j = j + 1;
        };

        result
    }
}



//# run 0xCAFE::FormatState::format_graph --signers 0xB0B0



//# run 0xCAFE::FormatState::format_map --signers 0xB0B0



//# run 0xCAFE::FormatState::format_state_with_offset --signers 0xB0B0 --args true



//# run 0xCAFE::FormatState::format_state_with_offset --signers 0xB0B0 --args false
