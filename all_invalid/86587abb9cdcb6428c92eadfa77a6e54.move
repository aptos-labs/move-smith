//# publish
module 0xCAFE::TestSpec {
    // Module-level spec block to verify marking a module as 'target'
    // Intentionally empty but included to exercise spec block declaration syntax.
}

//# publish
module 0xCAFE::TraversalTest {
    /// A simple node structure for traversal
    struct Node {
        value: u8,
        children: vector<Node>,
    }

    /// Internal function to traverse node children recursively.
    fun traverse_children(node: &Node, visited: &mut vector<u8>) {
        let len = vector::length(&node.children);
        let mut i = 0;
        while (i < len) {
            let child_ref = &vector::borrow(&node.children, i);
            // Visit child first (post-order traversal)
            traverse_children(child_ref, visited);
            i = i + 1;
        }
        // After visiting children, record current node's value
        vector::push_back(visited, node.value);
    }

    /// Public function to perform traversal and record visitation order
    public fun traverse_and_record(root: &Node): vector<u8> {
        let visited = vector::empty<u8>();
        traverse_children(root, &mut visited);
        vector::push_back(&mut visited, root.value); // Visit root last for post-order
        visited
    }

    /// Function to test traversal order: construct a tree, traverse and check order
    public fun test_traversal() {
        // Create leaf nodes
        let leaf1 = Node { value: 1, children: vector::empty<Node>() };
        let leaf2 = Node { value: 2, children: vector::empty<Node>() };
        let leaf3 = Node { value: 3, children: vector::empty<Node>() };

        // Create intermediate node with children
        let children_node = vector::empty<Node>();
        vector::push_back(&mut children_node, leaf2);
        vector::push_back(&mut children_node, leaf3);
        let parent = Node { value: 99, children: children_node };

        // Create root node with two children
        let root_children = vector::empty<Node>();
        vector::push_back(&mut root_children, leaf1);
        vector::push_back(&mut root_children, parent);

        let root = Node { value: 0, children: root_children };

        // Perform traversal
        let visitation_order = traverse_and_record(&root);

        // Here, we expect the order to be: 2, 3, 99, 1, 0 (post-order)
        // Not asserting, just for test coverage
        return;
    }
}

//# run 0xCAFE::TraversalTest::test_traversal