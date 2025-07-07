//# publish
module 0xCAFE::DependencyTracker {
    use std::vector;
    use std::string;

    struct ModuleInfo has copy, drop, store {
        name: vector<u8>,
        version: u8,
        dependencies: vector<vector<u8>>,
    }

    /// Stores usage info for modules (in reality this might be global storage, here simplified)
    struct UsageStore has key {
        infos: vector<ModuleInfo>,
    }

    public fun create_module_info(name: vector<u8>, version: u8, deps: vector<vector<u8>>): ModuleInfo {
        ModuleInfo {
            name,
            version,
            dependencies: deps,
        }
    }

    public fun add_module_info(store: &mut UsageStore, info: ModuleInfo) {
        vector::push_back(&mut store.infos, info);
    }

    public fun get_dependencies(store: &UsageStore, mod_name: &vector<u8>): vector<vector<u8>> {
        let len = vector::length(&store.infos);
        let mut i = 0;
        while (i < len) {
            let info_ref = &vector::borrow(&store.infos, i);
            if (*info_ref.name == *mod_name) {
                return vector::copy(&info_ref.dependencies);
            };
            i = i + 1;
        };
        vector::empty<vector<u8>>()
    }

    public fun no_arg_runner(): UsageStore {
        let deps0 = vector::empty<vector<u8>>();
        let info0 = create_module_info(b"CoreModule", 1, deps0);

        let mut deps1 = vector::empty<vector<u8>>();
        vector::push_back(&mut deps1, b"CoreModule");
        let info1 = create_module_info(b"ExtraModule", 2, deps1);

        let mut usage_store = UsageStore { infos: vector::empty<ModuleInfo>() };
        add_module_info(&mut usage_store, info0);
        add_module_info(&mut usage_store, info1);
        usage_store
    }

    public fun test_dependencies(store: UsageStore) {
        let deps_extra = get_dependencies(&store, &b"ExtraModule");
        let deps_core = get_dependencies(&store, &b"CoreModule");

        // Just access to test runtime, no asserts needed.
        let _ = vector::length(&deps_extra);
        let _ = vector::length(&deps_core);
    }

    // Test variable shadowing and assignment in closure
    public fun test_shadowing_and_closure(x: u8): u8 {
        let y = x + 1;
        let adder = |x: u8| {
            // shadow outer x parameter via closure param
            let x = x + 10;
            x
        };
        let y = adder(y);
        y
    }

    // Test destructuring with bindings on left hand side of assignment
    public fun test_destructuring() {
        let (mut a, mut b) = (1u8, 2u8);
        (a, b) = (b, a);
        let (mut c, mut d) = (3u8, 4u8);
        (c, d) = (a, b);
        (c, d)
    }
}

//# run 0xCAFE::DependencyTracker::no_arg_runner

//# run 0xCAFE::DependencyTracker::test_dependencies --args 0xCAFE::DependencyTracker::no_arg_runner

//# run 0xCAFE::DependencyTracker::test_shadowing_and_closure --args 5u8

//# run 0xCAFE::DependencyTracker::test_destructuring

// Featurres:
// 1b661c9a2c87e79c4a20945851a07de2: Access a module's usage information to track dependencies
// 061fadf74953f74c4f90eec9d94e5870: Test that variable shadowing and assignment within closures work correctly, ensuring that parameters can be renamed and assigned as expected inside inline function calls.
// 65956de78413f8034788b30e292edc4e: Declare and use variable bindings in destructuring assignments on the left-hand side of a Move assignment
