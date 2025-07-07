
//# publish
module 0xCAFE::ClosureCapture {
    // Removed unused 'signer' import
    // use std::signer;

    // A simple module to test closures capturing arguments and calling local module functions multiple times.
    struct Counter has store {
        count: u64,
    }

    public fun inc_counter(counter: &mut Counter) {
        counter.count = counter.count + 1;
    }

    public fun create_counter(): Counter {
        Counter { count: 0 }
    }

    // Fix the closure syntax by removing the explicit type annotation with () tuple
    public fun call_closure_multiple_times(x: u64): u64 {
        let counter = create_counter();

        // Closure capturing &mut counter and calling local function inc_counter
        // We can't explicitly type closures with tuple types in Move, so just leave it implicit.
        let closure = || {
            inc_counter(&mut counter);
        };

        closure();
        closure();
        closure();

        counter.count + x
    }
}



//# run 0xCAFE::ClosureCapture::call_closure_multiple_times --args 5u64




//# publish
module 0xCAFE::RecursiveChecker {
    use std::vector;

    // We cannot have recursive structs directly in Move. So instead, refactor Node to use vector<u64> of child ids.
    // Or alter children to vector<u64> and keep node store separately or use indexes (simulate tree)

    // For simplicity, store only children ids (u64) instead of Node structs to avoid recursive issue.
    struct Node has store {
        id: u64,
        children: vector<u64>,
    }

    public fun create_node_with_children(id: u64, num_children: u64): Node {
        let children = vector::empty<u64>();
        let i = 0u64;
        while (i < num_children) {
            vector::push_back(&mut children, i);
            i = i + 1;
        };
        Node {id, children}
    }

    // Counting nodes by counting children ids, simulate recursively by counting every child as 1 (no grandchildren here)
    // Since Node no longer has recursive nested Nodes, just total = 1 + length(children)
    public fun count_nodes(node: &Node): u64 {
        1 + vector::length(&node.children)
    }

    // Runner function that creates a node with children and returns the total count
    public fun run_checker(): u64 {
        let root = create_node_with_children(100, 3);
        count_nodes(&root)
    }
}



//# run 0xCAFE::RecursiveChecker::run_checker




//# publish
module 0xCAFE::OptionalTypeParameter {
    // Demonstrates function with optional type parameters using generics

    // A simple struct for demonstration
    struct Wrapper<T> has copy, drop {
        value: T,
    }

    // A function with a type parameter T defaulting to u64 (simulated by requiring explicit T, but caller can use u64)
    public fun wrap_value<T: copy + drop>(val: T): Wrapper<T> {
        Wrapper { value: val }
    }

    // A runner function explicitly wrapping u64 and bool (simulating optional typing scenario)
    public fun run_wraps(): (Wrapper<u64>, Wrapper<bool>) {
        let w1 = wrap_value<u64>(42u64);
        let w2 = wrap_value<bool>(true);
        (w1, w2)
    }
}



//# run 0xCAFE::OptionalTypeParameter::run_wraps
