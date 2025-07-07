
//# publish
module 0xBABE::DependencyGraph {
    use std::vector;

    struct Node has copy, drop, store {
        id: u8,
        dependencies: vector<u8>,
    }

    public fun create_node(id: u8, deps: vector<u8>): Node {
        Node {id, dependencies: deps}
    }

    public fun get_dependencies(node: &Node): &vector<u8> {
        &node.dependencies
    }

    public fun build_dependency_graph(): vector<Node> {
        let node_a = create_node(1, vector::empty<u8>());
        let node_b = create_node(2, vector::singleton(1u8));
        let node_c = create_node(3, vector::singleton(2u8));
        let node_d = create_node(4, vector::singleton(1u8));
        vector::merge(vector::merge(vector::merge(vector::singleton(node_a), vector::singleton(node_b)), vector::singleton(node_c)), vector::singleton(node_d))
    }
}


//# run 0xBABE::DependencyGraph::build_dependency_graph


//# publish
module 0xBABE::FeatureTest {
    use std::vector;
    use 0xBABE::DependencyGraph;

    struct Config<T> has copy, drop {
        param: T,
        flag: bool,
    }

    // A function with an optional type parameter
    public fun conditional_type<T>(x: T, y: bool): T {
        if (y) {
            x
        } else {
            // instantiate with default value, assuming T is u8 for simplicity
            0u8 as T
        }
    }

    // Function to test conditional branches with if_else expression
    public fun test_conditional_branch(cond: bool): u8 {
        let result = if_else (cond) {
            10u8
        } else {
            20u8
        };
        result
    }

    // Function that conditionally constructs data with different branches
    public fun feature_branch(input: u8, condition: bool): (u8, u8) {
        let val1: u8;
        let val2: u8;
        if_else (condition) {
            val1 = input + 1u8;
            val2 = input + 2u8;
        } else {
            val1 = input + 3u8;
            val2 = input + 4u8;
        };
        (val1, val2)
    }

    // Runner functions for simple call testing
    public fun run_conditional_type() {
        let _ = conditional_type<u8>(5u8, true);
        let _ = conditional_type<u8>(5u8, false);
    }

    public fun run_feature_branch() {
        let _ = feature_branch(7u8, true);
        let _ = feature_branch(7u8, false);
    }
}


//# run 0xBABE::FeatureTest::run_conditional_type

//# run 0xBABE::FeatureTest::run_feature_branch


// Featurres:
// 94edb5e14905208dab6e3d3dc730616e: Construct a directed dependency graph of modules based on their dependencies.
// 161e7adce5b7c3f41de21542ac64ac82: Define function signatures with optional type parameters in specifications.
// 817f78ceb6c33c6b4c3aab22d5889843: Write conditional branches using the `if_else` expression with then and optional else branches.
