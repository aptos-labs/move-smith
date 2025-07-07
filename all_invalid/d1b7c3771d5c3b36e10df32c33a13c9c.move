
//# publish
module 0xCAFE::RecursiveCheck {
    use std::option;

    struct Node has copy, drop, store, key {
        val: u8,
        next: option::Option<Node>,
    }

    public fun create_single_node(): Node {
        Node { val: 42, next: option::none<Node>() }
    }

    public fun create_two_nodes(): Node {
        let node2 = Node { val: 43, next: option::none<Node>() };
        Node { val: 42, next: option::some(node2) }
    }

    public fun runner() {
        let _ = create_single_node();
        let _ = create_two_nodes();
    }
}



//# run 0xCAFE::RecursiveCheck::runner




//# publish
module 0xCAFE::PkgModule1 {
    public fun runner1(x: u8): u8 {
        x + 1
    }
}



//# publish
module 0xCAFE::PkgModule2 {
    public fun runner2(x: u8): u8 {
        x + 2
    }
}



//# run 0xCAFE::PkgModule1::runner1 --args 10u8



//# run 0xCAFE::PkgModule2::runner2 --args 20u8




//# publish
module 0xCAFE::FuncReturn {
    public fun returns_function(): (|u8|u8) {
        |x: u8| { x + 5 }
    }

    public fun runner_return_func(): u8 {
        let f = returns_function();
        f(10u8)
    }
}



//# run 0xCAFE::FuncReturn::runner_return_func


// Featurres:
// d46da021d7cad51cc60e73f0334676f4: Target specific modules for recursive structure checking.
// ae7648d2f1a91ce9629afa86e0cd2a86: Include multiple modules under a single named address in Move packages.
// ae915a9726a36c11d4f1d384f1a96087: Allow functions to return function-typed values at the top level if the language version is at least 2.2.
