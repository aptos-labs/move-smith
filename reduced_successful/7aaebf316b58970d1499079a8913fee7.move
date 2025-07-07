
//# publish
module 0xCAFE::CycleGraph {
    use std::vector;

    struct Graph has copy, drop {
        edges: vector<vector<u8>>, // adjacency list for up to 256 nodes
    }

    public fun new_node(graph: &mut Graph) {
        let empty_vec = vector::empty<u8>();
        vector::push_back(&mut graph.edges, empty_vec);
    }

    public fun add_edge(graph: &mut Graph, from: u8, to: u8) {
        let edges_vec = vector::borrow_mut(&mut graph.edges, from as u64);
        vector::push_back(edges_vec, to);
    }

    fun dfs(
        graph: &Graph,
        node: u8,
        visited: &mut vector<bool>,
        rec_stack: &mut vector<bool>
    ): bool {
        if (*vector::borrow(visited, node as u64)) {
            false
        } else {
            // Instead of assigning like `vector::borrow_mut(...) = true;`
            // get a mutable reference and write into it
            let visited_item_ref = vector::borrow_mut(visited, node as u64);
            *visited_item_ref = true;

            let rec_stack_item_ref = vector::borrow_mut(rec_stack, node as u64);
            *rec_stack_item_ref = true;

            let neighbors = vector::borrow(&graph.edges, node as u64);
            let i = 0u64;
            while (i < vector::length(neighbors)) {
                let adj = *vector::borrow(neighbors, i);
                if (!*vector::borrow(visited, adj as u64) && dfs(graph, adj, visited, rec_stack)) {
                    return true;
                };
                if (*vector::borrow(rec_stack, adj as u64)) {
                    return true;
                };
                i = i + 1;
            };
            let rec_stack_item_ref = vector::borrow_mut(rec_stack, node as u64);
            *rec_stack_item_ref = false;
            false
        }
    }

    public fun has_cycle(graph: &Graph, start_node: u8): bool {
        let n = vector::length(&graph.edges);
        let visited = vector::empty<bool>();
        let rec_stack = vector::empty<bool>();
        let i = 0u64;
        while (i < n) {
            vector::push_back(&mut visited, false);
            vector::push_back(&mut rec_stack, false);
            i = i + 1;
        };
        dfs(graph, start_node, &mut visited, &mut rec_stack)
    }

    public fun sample_graph_with_cycle(): Graph {
        let graph = Graph {edges: vector::empty<vector<u8>>()};
        new_node(&mut graph); // node 0
        new_node(&mut graph); // node 1
        new_node(&mut graph); // node 2
        add_edge(&mut graph, 0, 1);
        add_edge(&mut graph, 1, 2);
        add_edge(&mut graph, 2, 0); // cycle 0->1->2->0
        graph
    }

    public fun sample_graph_without_cycle(): Graph {
        let graph = Graph {edges: vector::empty<vector<u8>>()};
        new_node(&mut graph); // node 0
        new_node(&mut graph); // node 1
        new_node(&mut graph); // node 2
        add_edge(&mut graph, 0, 1);
        add_edge(&mut graph, 1, 2);
        graph
    }

    public fun runner_cycle_check(): bool {
        let g_cycle = sample_graph_with_cycle();
        let g_no_cycle = sample_graph_without_cycle();
        let has_cycle1 = has_cycle(&g_cycle, 0);
        let has_cycle2 = has_cycle(&g_no_cycle, 0);
        assert!(has_cycle1, 123);
        assert!(!has_cycle2, 456);
        has_cycle1
    }
}



//# publish
module 0xCAFE::UtilFunctors {
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_nested(x: u8, y: u8): u8 {
        inline_add(x, y)
    }
}



//# publish
module 0xCAFE::LambdaTest {
    use 0xCAFE::UtilFunctors;

    public fun add_and_return_fixed_value(_a: u8, _b: u8): u8 {
        // Test that adding two u8 values and then returning 42
        // The original 'sum' is unused, prefix with _ to suppress warnings
        let _sum = _a + _b;
        42u8
    }

    public fun lambda_example(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun nested_inline_call(a: u8, b: u8): u8 {
        UtilFunctors::call_inline_nested(a, b)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_fixed_value --args 10u8 20u8



//# run 0xCAFE::LambdaTest::lambda_example --args 11u8 22u8



//# run 0xCAFE::LambdaTest::nested_inline_call --args 15u8 27u8



//# run 0xCAFE::CycleGraph::runner_cycle_check
