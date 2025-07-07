//# publish
module 0xCAFE::GraphCycleChecker {
    use std::vector;

    /// A simple graph stored as adjacency list.
    /// Each node is a u8 index. The graph is a vector of vectors.
    struct Graph has store, key {
        adj_list: vector<vector<u8>>,
    }

    /// Create a graph with given adjacency list
    public fun new_graph(adj_list: vector<vector<u8>>): Graph {
        Graph { adj_list }
    }

    /// Return the neighbors of a node
    public fun neighbors(graph: &Graph, node: u8): &vector<u8> {
        // We assume node < vector length
        &vector::borrow(&graph.adj_list, node as usize)
    }
    
    /// A helper function to check if vector contains an element
    public fun contains(v: &vector<u8>, elem: u8): bool {
        let len = vector::length(v);
        let mut i = 0;
        while (i < len) {
            if (*vector::borrow(v, i) == elem) {
                return true;
            }
            i = i + 1;
        }
        false
    }

    /// Walk neighbors recursively to detect cycles - depth limited to avoid infinite loops
    /// This deliberately creates nested non-native functions as a compile test.
    public fun has_cycle(graph: &Graph, start: u8): bool {
        /// Inner helper function to recurse over neighbors while tracking visited nodes.
        /// This function is non-native, should be compiled and run.
        fun dfs(visited: &mut vector<u8>, node: u8): bool {
            if (Self::contains(visited, node)) {
                // Cycle detected
                return true;
            };
            vector::push_back(visited, node);
            let nbrs = Self::neighbors(graph, node);
            let len = vector::length(nbrs);
            let mut i = 0;
            while (i < len) {
                let n = *vector::borrow(nbrs, i);
                if (dfs(visited, n)) {
                    return true;
                };
                i = i + 1;
            };
            vector::pop_back(visited);
            false
        }

        let mut visited = vector::empty<u8>();
        dfs(&mut visited, start)
    }

    /// Runner function to test has_cycle on a sample graph with a cycle
    public fun runner(): bool {
        let adj = vector::empty<vector<u8>>();
        // Node 0: neighbors 1 and 2
        vector::push_back(&mut adj, vector::from_bytes(b"\x01\x02"));
        // Node 1: neighbors 2
        vector::push_back(&mut adj, vector::from_bytes(b"\x02"));
        // Node 2: neighbor 0 (cycle back to 0)
        vector::push_back(&mut adj, vector::from_bytes(b"\x00"));
        let graph = Self::new_graph(adj);
        Self::has_cycle(&graph, 0)
    }
}
 //# run 0xCAFE::GraphCycleChecker::runner

//# publish
module 0xCAFE::AnsiDiagnostic {
    use std::vector;
   
    /// An enum for testing purposes (copy and drop abilities)
    enum Level has copy, drop {
        Info,
        Warning,
        Error,
    }

    /// Function that returns a colored diagnostic message if ENV variable ANSI is set to "ANSI".
    /// This demonstrates conditional compilation and string vector usage.
    public fun diagnostic_message(level: Level, message: vector<u8>): vector<u8> {
        let ansi = env::get_var("ENV");
        let is_ansi = match ansi {
            Some(v) => vector::length(&v) == 4 &&
                (*vector::borrow(&v, 0) == 65u8) && // 'A'
                (*vector::borrow(&v, 1) == 78u8) && // 'N'
                (*vector::borrow(&v, 2) == 83u8) && // 'S'
                (*vector::borrow(&v, 3) == 73u8),   // 'I'
            None => false,
        };
        if (is_ansi) {
            let mut prefix = vector::empty<u8>();
            let mut suffix = vector::empty<u8>();
            // Add ANSI color code depending on level
            prefix = match level {
                Level::Info => b"\x1B[32m",      // Green
                Level::Warning => b"\x1B[33m",   // Yellow
                Level::Error => b"\x1B[31m",     // Red
            };
            suffix = b"\x1B[0m"; // Reset
            vector::concat(prefix, vector::concat(message, suffix))
        } else {
            // Return message as-is if not ANSI
            message
        }
    }

    /// A non-native helper to create messages (to test compiler for target modules)
    public fun compose_message(level: Level, text: vector<u8>): vector<u8> {
        diagnostic_message(level, text)
    }

    public fun runner(): vector<u8> {
        let msg = b"Error occurred\n";
        Self::diagnostic_message(Level::Error, msg)
    }
}
 //# run 0xCAFE::AnsiDiagnostic::runner

//# publish
module 0xCAFE::ModuleWithNonNativeFuncs {
    /// This module contains deliberately written non-native functions.
    /// `non_native_func_no_args` has no args.
    /// `non_native_func_with_args` has args.
    /// Both are never implemented here, compiler should check signature correctness.

    public non_native fun non_native_func_no_args(): u64;

    public non_native fun non_native_func_with_args(x: u8, y: u32): bool;

    /// A run function that does nothing but exists to test compilation.
    public fun runner() {
        // Just empty body, no usage of non_native here.
        // To test compiler coverage of non-native declarations.
        ()
    }
}
 //# run 0xCAFE::ModuleWithNonNativeFuncs::runner

//# run
script {
    use 0xCAFE::AnsiDiagnostic;
    use 0xCAFE::GraphCycleChecker;
    use 0xCAFE::ModuleWithNonNativeFuncs;

    fun main() {
        let result = GraphCycleChecker::runner();
        // The result is bool if cycle was detected. We ignore assertion.

        let ansi_msg = AnsiDiagnostic::runner();
        // ansi_msg is a vector<u8> representing colored diagnostic or just plain text.

        // Call the runner in module with non-native funcs to test compilation + VM execution
        ModuleWithNonNativeFuncs::runner();
    }
}

// Featurres:
// 8a8ce183c37cd9e15739542446920f83: Display diagnostics with ANSI color if environment variable is set to 'ANSI'.
// 6ca6437b2f44472e668d7612bc05c300: Walk through neighbors of the node to explore potential cycles.
// 6b96d6915bf62b0b7ab660278c334d1e: Write non-native functions within target modules that will be checked by the compiler.
