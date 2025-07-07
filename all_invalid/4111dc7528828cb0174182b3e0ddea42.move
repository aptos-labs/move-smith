
//# publish
module 0xCAFE::ClosureCapture {
    use std::signer;

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

    public fun call_closure_multiple_times(x: u64): u64 {
        let counter = create_counter();

        // Closure capturing &mut counter and calling local function inc_counter
        let closure: |()| () has drop = || {
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

    // A struct with a recursive-like structure through vectors of Self.
    struct Node has store {
        id: u64,
        children: vector<Node>,
    }

    public fun create_node_with_children(id: u64, num_children: u64): Node {
        let children = vector::empty<Node>();
        let i = 0u64;
        while (i < num_children) {
            let child = Node {id: i, children: vector::empty<Node>()};
            vector::push_back(&mut children, child);
            i = i + 1;
        };
        Node {id, children}
    }

    // Counts total nodes recursively
    public fun count_nodes(node: &Node): u64 {
        let total = 1;
        let len = vector::length(&node.children);
        let i = 0;
        while (i < len) {
            let child = vector::borrow(&node.children, i);
            total = total + count_nodes(child);
            i = i + 1;
        };
        total
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


// Featurres:
// abdaf3e04bbeb742adb0f5bff5199ee9: Test that closures capturing arguments and calling local module functions work correctly when invoked multiple times within the same function.
// c1d6ce0b3f7643dd3e81334940d5f993: Initialize and run a recursive structure checker on targeted modules.
// e31628f4163de8372dccf131b85a7559: Specify function parameters, including optional type parameters.
