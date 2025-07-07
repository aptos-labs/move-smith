
//# publish
module 0xCAFE::AbilityConstraintTest {
    use std::string;

    // Structs with different ability sets
    struct CopyOnly has copy {
        x: u8,
    }

    struct DropOnly has drop {
        x: u8,
    }

    struct StoreOnly has store {
        x: u8,
    }

    struct CopyDrop has copy, drop {
        x: u8,
    }

    struct CopyStore has copy, store {
        x: u8,
    }

    struct DropStore has drop, store {
        x: u8,
    }

    struct CopyDropStore has copy, drop, store {
        x: u8,
    }

    struct NoAbility {
        x: u8,
    }

    // Functions with ability constraints in parameters to test enforcement

    // Accepts only types with copy ability
    public fun takes_copy<T: copy>(_: T) {}

    // Accepts only types with drop ability
    public fun takes_drop<T: drop>(_: T) {}

    // Accepts only types with store ability
    public fun takes_store<T: store>(_: T) {}

    // Accepts types with copy and drop abilities
    public fun takes_copy_and_drop<T: copy + drop>(_: T) {}

    // Accepts types with copy and store abilities
    public fun takes_copy_and_store<T: copy + store>(_: T) {}

    // Accepts types with drop and store abilities
    public fun takes_drop_and_store<T: drop + store>(_: T) {}

    // Accepts types with copy, drop, store abilities
    public fun takes_copy_drop_store<T: copy + drop + store>(_: T) {}

    // Positive tests: call the above functions with compatible structs

    public fun positive_tests() {
        takes_copy(CopyOnly {x: 1});
        takes_drop(DropOnly {x: 2});
        takes_store(StoreOnly {x: 3});
        takes_copy_and_drop(CopyDrop {x: 4});
        takes_copy_and_store(CopyStore {x: 5});
        takes_drop_and_store(DropStore {x: 6});
        takes_copy_drop_store(CopyDropStore {x: 7});
    }

    // Negative tests: these should fail to compile if uncommented
    // But since this is a transactional test, we just show how errors
    // would look like as comments.

    /*
    // ERROR expected: CopyOnly lacks drop and store abilities
    public fun negative_test_1() {
        takes_drop(CopyOnly {x: 10});
    }

    // ERROR expected: DropOnly lacks copy and store abilities
    public fun negative_test_2() {
        takes_copy(DropOnly {x: 11});
    }

    // ERROR expected: NoAbility has no abilities
    public fun negative_test_3() {
        takes_store(NoAbility {x: 12});
    }

    // ERROR expected: CopyOnly lacks drop ability
    public fun negative_test_4() {
        takes_copy_and_drop(CopyOnly {x: 13});
    }
    */

    // Simulate compiler warnings reporting

    // Warning enum to simulate warning kinds
    enum WarningKind {
        UnusedVariable,
        DeprecatedFeature,
        ShadowedVariable,
    }

    // Warning struct
    struct Warning has copy, drop {
        kind: WarningKind,
        message: vector<u8>,
    }

    // Collector for warnings
    struct WarningCollector has store {
        warnings: vector<Warning>,
    }

    // Store one warning, simulating compiler collecting warnings
    public fun add_warning(collector: &mut WarningCollector, kind: WarningKind, msg: vector<u8>) {
        let warning = Warning { kind, message: msg };
        vector::push_back(&mut collector.warnings, warning);
    }

    // Create a new empty warning collector
    public fun new_warning_collector(): WarningCollector {
        WarningCollector { warnings: vector::empty<Warning>() }
    }

    // Report warnings as a single string with newline separates
    public fun report_warnings(collector: &WarningCollector): vector<u8> {
        let result = vector::empty<u8>();
        let len = vector::length(&collector.warnings);
        let i = 0u64;
        while (i < len) {
            let warning = *vector::borrow(&collector.warnings, i as usize);
            // Prefix message by kind string
            let prefix = match (warning.kind) {
                WarningKind::UnusedVariable => b"Warning: Unused variable - ",
                WarningKind::DeprecatedFeature => b"Warning: Deprecated feature - ",
                WarningKind::ShadowedVariable => b"Warning: Shadowed variable - ",
            };
            vector::append(&mut result, prefix);
            vector::append(&mut result, warning.message);
            vector::push_back(&mut result, 10); // '\n'
            i = i + 1;
        };
        result
    }

    // Test function to generate warnings and report them
    public fun test_report_warnings(): vector<u8> {
        let collector = new_warning_collector();
        add_warning(&mut collector, WarningKind::UnusedVariable, b"variable x is never read");
        add_warning(&mut collector, WarningKind::DeprecatedFeature, b"old function f() is deprecated");
        add_warning(&mut collector, WarningKind::ShadowedVariable, b"variable y shadows outer variable");
        report_warnings(&collector)
    }

    // Local variable initialization status reporting

    // We simulate some diagnostics by text and counts

    public fun report_local_init_status(initialized: bool, uninitialized_vars: vector<vector<u8>>): vector<u8> {
        if (initialized) {
            b"All locals are initialized\n"
        } else {
            let result = b"Uninitialized locals: ";
            let len = vector::length(&uninitialized_vars);
            let i = 0u64;
            while (i < len) {
                let var_name = vector::borrow(&uninitialized_vars, i as usize);
                vector::append(&mut result, var_name);
                if (i + 1 < len) {
                    vector::push_back(&mut result, b',' as u8);
                    vector::push_back(&mut result, b' ' as u8);
                };
                i = i + 1;
            };
            vector::push_back(&mut result, 10);
            result
        }
    }

    // Test function to call above for different cases
    public fun test_local_init_status(): (vector<u8>, vector<u8>) {
        // all initialized
        let x = report_local_init_status(true, vector::empty<vector<u8>>());
        // some uninitialized locals
        let vec_names = vector::empty<vector<u8>>();
        vector::push_back(&mut vec_names, b"a");
        vector::push_back(&mut vec_names, b"temp");
        vector::push_back(&mut vec_names, b"count");
        let y = report_local_init_status(false, vec_names);
        (x, y)
    }

    // Combined scenario testing

    // Function has ability constraints, triggers warning, and has uninitialized variable

    public fun combined_feature_test<T: copy + drop>(_: T) {
        // Let's simulate a warning collector usage & local status

        let collector = new_warning_collector();

        // Simulate a warning: unused variable z
        add_warning(&mut collector, WarningKind::UnusedVariable, b"variable z is never read");

        // Local variables initialization simulation:
        // x - initialized
        // y - uninitialized
        // z - initialized but unused

        // Compose uninitialized var list
        let uninit_vars = vector::empty<vector<u8>>();
        vector::push_back(&mut uninit_vars, b"y");

        let warning_str = report_warnings(&collector);
        let local_status_str = report_local_init_status(false, uninit_vars);

        // We just do no-op with these to showcase combined usage
        let _ = warning_str;
        let _ = local_status_str;
    }
}


//# run 0xCAFE::AbilityConstraintTest::positive_tests


//# run 0xCAFE::AbilityConstraintTest::test_report_warnings


//# run 0xCAFE::AbilityConstraintTest::test_local_init_status


//# run 0xCAFE::AbilityConstraintTest::combined_feature_test --args 0xCAFE::AbilityConstraintTest::CopyDropStore


// Featurres:
// a7d9e02846f38d0861a9526f153978f9: Check for ability constraints in the function signature to enforce type capabilities in your Move code.
// 141a23e611f2ad603051b0ff7caaf9e7: Review compiler warnings with severity 'Warning' by calling report_warnings() to display them to the user.
// 8c9e367b4b06e14c0a9e173292b83617: Generate a human-readable string indicating whether all local variables are initialized or specify which are not.
