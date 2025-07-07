module 0x1::TestCycleDependencyAndCallbacks {
    use std::vector;
    use std::debug;
    use std::signer;
    use std::string;
    use std::address;

    // ============ Resource & callback setup ============

    resource struct ResourceCount has key {
        count: u64,
    }

    /// Callback interface: callback function modifies ResourceCount
    spec callback<T> {
        fun call(resource_count: &mut ResourceCount);
    }

    /// A simple callback struct implementing a callback interface
    struct IncrementCallback has copy, drop, store {}

    /// Invokes a callback interface on ResourceCount; simulate module lock by restricting caller
    public fun run_callback(resource_count: &mut ResourceCount, cb: &IncrementCallback) acquires ResourceCount {
        // Let's simulate "module lock" by having 'run_callback' marked with "acquires ResourceCount"

        // Before callback, check count
        let before = resource_count.count;

        // Call the callback (in reality would be a generic or trait; here inline)
        IncrementCallback::callback(resource_count);

        // After callback, count should be incremented by 1
        let after = resource_count.count;
        assert!(after == before + 1, error_code_for_callback_not_applied());
    }

    /// Implementation of IncrementCallback callback interface
    public fun callback(resource_count: &mut ResourceCount) {
        resource_count.count = resource_count.count + 1;
    }

    fun error_code_for_callback_not_applied(): u64 {
        2000
    }

    // ============ Dependency Graph Cycle Analysis ============

    /// Represents a module.ref dependency edge
    struct ModuleRef has copy, drop, store {
        from: address,
        to: address,
    }

    /// Analyzes dependency graph edges to find minimal cycles.
    /// For simplicity, uses a DFS approach to detect cycles.
    /// Returns true if there is at least one cycle.
    public fun detect_minimal_cycles(edges: &vector<ModuleRef>): bool {
        // For this small test, we'll build adjacency list as vector<vector<address>>
        // Since addresses are not enumerable easily, we'll collect unique modules first.

        let modules = collect_unique_modules(edges);
        let len = vector::length(&modules);

        // Build adjacency matrix: bool[len][len]
        let mut adjacency = vector::empty<vector<bool>>();
        let i = 0;
        while (i < len) {
            vector::push_back(&mut adjacency, vector::empty<bool>());
            let j = 0;
            while (j < len) {
                vector::push_back(&mut vector::borrow_mut(&mut adjacency, i), false);
                j = j + 1;
            }
            i = i + 1;
        }

        // Fill adjacency
        let k = 0;
        while (k < vector::length(edges)) {
            let edge = *vector::borrow(edges, k);
            let from_idx = index_of(&modules, edge.from);
            let to_idx = index_of(&modules, edge.to);
            if (from_idx != len && to_idx != len) {
                *vector::borrow_mut(&mut vector::borrow_mut(&mut adjacency, from_idx), to_idx) = true;
            }
            k = k + 1;
        }

        // DFS to find any cycle
        let mut visited = vector::empty<bool>();
        let mut stack = vector::empty<bool>();
        let i2 = 0;
        while (i2 < len) {
            vector::push_back(&mut visited, false);
            vector::push_back(&mut stack, false);
            i2 = i2 + 1;
        }

        let i3 = 0;
        while (i3 < len) {
            if (!vector::borrow(&visited, i3)) {
                if (dfs_cycle(i3, &adjacency, &mut visited, &mut stack)) {
                    return true;
                }
            }
            i3 = i3 + 1;
        }

        false
    }

    fun dfs_cycle(
        node: u64,
        adjacency: &vector<vector<bool>>,
        visited: &mut vector<bool>,
        stack: &mut vector<bool>
    ): bool {
        *vector::borrow_mut(visited, node) = true;
        *vector::borrow_mut(stack, node) = true;

        let neighbors = vector::borrow(adjacency, node);
        let len = vector::length(neighbors);
        let i = 0;
        while (i < len) {
            if (*vector::borrow(neighbors, i)) {
                if (!*vector::borrow(visited, i) && dfs_cycle(i, adjacency, visited, stack)) {
                    return true;
                } else if (*vector::borrow(stack, i)) {
                    // Cycle found
                    return true;
                }
            }
            i = i + 1;
        }

        *vector::borrow_mut(stack, node) = false;
        false
    }

    fun collect_unique_modules(edges: &vector<ModuleRef>): vector<address> {
        let mut seen = vector::empty<address>();
        let len = vector::length(edges);
        let i = 0;
        while (i < len) {
            let edge = *vector::borrow(edges,i);
            if (!contains(&seen, edge.from)) {
                vector::push_back(&mut seen, edge.from);
            }
            if (!contains(&seen, edge.to)) {
                vector::push_back(&mut seen, edge.to);
            }
            i = i + 1;
        }
        seen
    }

    fun contains(vec: &vector<address>, addr: address): bool {
        let len = vector::length(vec);
        let i = 0;
        while (i < len) {
            if (*vector::borrow(vec, i) == addr) {
                return true;
            }
            i = i + 1;
        }
        false
    }

    fun index_of(vec: &vector<address>, addr: address): u64 {
        let len = vector::length(vec);
        let i = 0;
        while (i < len) {
            if (*vector::borrow(vec, i) == addr) {
                return i;
            }
            i = i + 1;
        }
        len // not found returns len (out of range)
    }

    // ============ Compiler Diagnostics Simulation ============

    /// Simulate compiler diagnostics for provided Move source strings.
    /// Returns vector<string> of diagnostics messages.
    public fun get_compiler_diagnostics(sources: &vector<string::String>): vector<string::String> {
        let mut diags = vector::empty<string::String>();
        let len = vector::length(sources);

        let i = 0;
        while (i < len) {
            let src = vector::borrow(sources, i);
            if (string::contains(src, "error")) {
                vector::push_back(&mut diags, string::utf8(b"Error: found 'error' in source"));
            } else if (string::contains(src, "warn")) {
                vector::push_back(&mut diags, string::utf8(b"Warning: found 'warn'"));
            } else {
                vector::push_back(&mut diags, string::utf8(b"No issues"));
            }
            i = i + 1;
        }

        diags
    }

    // ============ Transactional Test Entry Point ============

    #[test_only]
    public entry fun transactional_test(signer: &signer) {
        // === Part 1: Test dependency graph cycle detection ===
        let edges = vector::empty<ModuleRef>();

        // Setup a simple graph with a minimal cycle:
        // ModA (0xA) -> ModB (0xB)
        // ModB (0xB) -> ModC (0xC)
        // ModC (0xC) -> ModA (0xA)  <-- cycle

        vector::push_back(&mut edges, ModuleRef { from: 0xA, to: 0xB });
        vector::push_back(&mut edges, ModuleRef { from: 0xB, to: 0xC });
        vector::push_back(&mut edges, ModuleRef { from: 0xC, to: 0xA });

        let has_cycle = detect_minimal_cycles(&edges);
        debug::print(&string::utf8(b"[Test] Dependency graph cycle detected: "));
        if (has_cycle) {
            debug::print(&string::utf8(b"YES"));
        } else {
            debug::print(&string::utf8(b"NO"));
        }
        assert!(has_cycle, 1001); // Expect cycle true

        // === Part 2: View compiler diagnostics simulation ===
        let sources = vector::empty<string::String>();
        vector::push_back(&mut sources, string::utf8(b"module MyModule {}"));
        vector::push_back(&mut sources, string::utf8(b"error something wrong"));
        vector::push_back(&mut sources, string::utf8(b"warn check this"));

        let diags = get_compiler_diagnostics(&sources);
        debug::print(&string::utf8(b"[Test] Compiler diagnostics:"));

        let dlen = vector::length(&diags);
        let i = 0;
        while (i < dlen) {
            debug::print(vector::borrow(&diags, i));
            i = i + 1;
        }

        // Expect diagnostics count = 3
        assert!(dlen == 3, 1002);

        // === Part 3: Testing callback within module locked function (resource acquires) ===

        // Publish ResourceCount resource under signer
        move_to(signer, ResourceCount { count: 0 });

        // Borrow &mut resource
        let rc_ref = borrow_global_mut<ResourceCount>(signer::address_of(signer));

        // Create callback instance
        let cb = IncrementCallback {};

        // Run callback inside "module-locked" function
        run_callback(rc_ref, &cb);

        // After callback, count should be 1
        assert!(rc_ref.count == 1, 1003);

        // Clean up resource
        move_from<ResourceCount>(signer::address_of(signer));

        debug::print(&string::utf8(b"[Test] All tests passed."));
    }
}

// Featurres:
// 74454629fd6094069b32ea18cde73d14: Analyze dependency graphs to identify minimal cycles in module references
// b81ec7d4fec8c34fc7478d659cac559c: View detailed compiler diagnostics associated with your Move source files
// 03dea97c0dddd7a0153ef576a26b8699: Test that calling a callback function within a module-locked function modifies the resource count as expected, verifying that module lock constraints are enforced during callback execution.
