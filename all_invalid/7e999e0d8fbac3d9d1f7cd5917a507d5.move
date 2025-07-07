
//# publish
module 0xCAFE::GraphTraversal {
    use std::vector;
    use std::string;

    // A simple graph node struct with store ability
    struct GraphNode has store, key {
        id: u8,
        neighbors: vector<u8>,
    }

    struct Visited has copy, drop, store {
        values: vector<bool>,
    }

    // Create a graph node with given id and neighbors
    public fun new_node(id: u8, neighbors: vector<u8>): GraphNode {
        GraphNode { id, neighbors }
    }

    // Package-visible function to inspect a node's neighbors; returns their count
    package fun neighbor_count(node: &GraphNode): u8 {
        (vector::length(&node.neighbors) as u8)
    }

    // Package-visible function to detect cycles starting from current node
    // Uses DFS traversal with visited vector passed as mutable reference
    package fun detect_cycle(node: &GraphNode, graph: &vector<GraphNode>, visited: &mut Visited, stack: &mut vector<bool>): bool {
        let id = node.id as usize;
        if (*vector::borrow(&visited.values, id)) {
            false
        } else {
            vector::borrow_mut(&mut visited.values, id) = true;
            vector::borrow_mut(stack, id) = true;

            // Lambda with no capture to check neighbors for cycle
            let check_neighbor: |&u8|bool has copy+drop = |neighbor_id: &u8| {
                let idx = *neighbor_id as usize;
                if (*vector::borrow(&stack, idx)) {
                    // Cycle detected
                    true
                } else if !(*vector::borrow(&visited.values, idx)) {
                    let next_node_ref = &*vector::borrow(graph, idx);
                    detect_cycle(next_node_ref, graph, visited, stack)
                } else {
                    false
                }
            };

            let found_cycle = false;

            // Iterate neighbors
            let neighbors = &node.neighbors;
            let neighbors_len = vector::length(neighbors);
            let i = 0;
            while (i < neighbors_len && !found_cycle) {
                let neighbor_id_ref = vector::borrow(neighbors, i);
                found_cycle = check_neighbor(neighbor_id_ref);
                i = i + 1;
            };

            // Lambda capturing found_cycle by ref as bool wrapper
            let reset_stack: |()|() has copy+drop = || {
                vector::borrow_mut(stack, id) = false;
            };

            reset_stack();

            found_cycle
        }
    }

    // Package-visible function that runs neighbor count and cycle detection on a sample graph
    // Returns pair: (neighbor_count_of_node0, detected_cycle)
    package fun run_test() : (u8, bool) {
        // build graph with 3 nodes: 0,1,2 and edges 0->1, 1->2, 2->0 (cycle)
        let node0 = new_node(0, vector[1]);
        let node1 = new_node(1, vector[2]);
        let node2 = new_node(2, vector[0]);
        let graph = vector[node0, node1, node2];

        let visited = Visited { values: vector[false, false, false] };
        let stack = vector[false, false, false];

        let count = neighbor_count(&vector::borrow(&graph, 0));

        // detect cycle starting at node0
        let cycle_found = detect_cycle(&vector::borrow(&graph, 0), &graph, &mut visited, &mut stack);

        (count, cycle_found)
    }
}


//# run 0xCAFE::GraphTraversal::run_test


// Featurres:
// 6ca6437b2f44472e668d7612bc05c300: Walk through neighbors of the node to explore potential cycles.
// 40695500bde0323f00aa864d292abae6: Declare functions or modules with 'package' visibility to restrict access within the same package.
// c163b3213962928e29d1b57d9b6a4b2a: Use the syntax '|' to start lambda capture lists, possibly with captures or empty.
