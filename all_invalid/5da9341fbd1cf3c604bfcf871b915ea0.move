// Named address mapping
address 0xCAFE {
    module Graph {
        // A simple graph implemented as adjacency list with neighbors

        use std::vector;

        /// Graph is stored as a vector of vectors of u8 representing neighbors
        resource struct Graph {
            adjacency: vector<vector<u8>>,
        }

        /// Initialize graph resource with n nodes
        public fun initialize_graph(account: &signer, n: u8) {
            let mut adjacency = vector::empty<vector<u8>>();
            let mut i = 0;
            while (i < n) {
                vector::push_back(&mut adjacency, vector::empty<u8>());
                i = i + 1;
            };
            move_to(account, Graph { adjacency })
        }

        /// Add directed edge from node `from` to node `to`
        public fun add_edge(graph: &mut Graph, from: u8, to: u8) {
            // Add 'to' to adjacency list of 'from'
            let neighbors = vector::borrow_mut(&mut graph.adjacency, from as usize);
            vector::push_back(neighbors, to);
        }

        /// Walk neighbors from a start node and visit nodes to explore potential cycles
        /// This function simply walks neighbors once (not a full cycle detection), to exercise nested calls
        public fun walk_neighbors(graph: &Graph, start: u8) {
            let neighbors = vector::borrow(&graph.adjacency, start as usize);
            let len = vector::length(neighbors);
            let mut i = 0;
            while (i < len) {
                let neighbor = *vector::borrow(neighbors, i);
                // Visit neighbor node (dummy call)
                Self::visit_node(neighbor);
                i = i + 1;
            };
        }

        /// Visit node (dummy function to test valid naming, no underscore)
        public fun visit_node(_node: u8) {
            // No-op function
        }

        /// Runner: create a graph, add edges and walk neighbors
        public fun runner(account: &signer) {
            Self::initialize_graph(account, 3);
            let graph_ref = borrow_global_mut<Graph>(signer::address_of(account));
            Self::add_edge(graph_ref, 0, 1);
            Self::add_edge(graph_ref, 1, 2);
            Self::add_edge(graph_ref, 2, 0); // edge creating potential cycle
            Self::walk_neighbors(graph_ref, 0);
        }
    }
}

//# publish
address 0xCAFE {
    module Graph {
        use std::vector;

        resource struct Graph {
            adjacency: vector<vector<u8>>,
        }

        public fun initialize_graph(account: &signer, n: u8) {
            let mut adjacency = vector::empty<vector<u8>>();
            let mut i = 0;
            while (i < n) {
                vector::push_back(&mut adjacency, vector::empty<u8>());
                i = i + 1;
            };
            move_to(account, Graph { adjacency })
        }

        public fun add_edge(graph: &mut Graph, from: u8, to: u8) {
            let neighbors = vector::borrow_mut(&mut graph.adjacency, from as usize);
            vector::push_back(neighbors, to);
        }

        public fun walk_neighbors(graph: &Graph, start: u8) {
            let neighbors = vector::borrow(&graph.adjacency, start as usize);
            let len = vector::length(neighbors);
            let mut i = 0;
            while (i < len) {
                let neighbor = *vector::borrow(neighbors, i);
                Self::visit_node(neighbor);
                i = i + 1;
            };
        }

        public fun visit_node(_node: u8) {}

        public fun runner(account: &signer) {
            Self::initialize_graph(account, 3);
            let graph_ref = borrow_global_mut<Graph>(signer::address_of(account));
            Self::add_edge(graph_ref, 0, 1);
            Self::add_edge(graph_ref, 1, 2);
            Self::add_edge(graph_ref, 2, 0);
            Self::walk_neighbors(graph_ref, 0);
        }
    }
}

//# run 0xCAFE::Graph::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::Graph;

    fun main(account: &signer) {
        Graph::runner(account);
    }
}

// Featurres:
// ab30c100cc87c3b942d32a1ee4b281bb: Use named address mapping to refer to addresses in your Move code
// 3d6277f840bcbd49556e05ceef3c717d: Use valid module member names that do not start with an underscore for functions.
// 6ca6437b2f44472e668d7612bc05c300: Walk through neighbors of the node to explore potential cycles.
