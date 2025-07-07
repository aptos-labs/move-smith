//# publish
module 0xCAFE::PathConflictDetector {
    // This module simulates detection logic for path conflicts.
    // In Move, actual file/path handling is outside the language,
    // but we simulate by storing and comparing string paths.

    use std::string;
    use std::vector;

    struct PathList has store {
        paths: vector<vector<u8>>,
    }

    public fun create_path_list(): PathList {
        let v = vector::empty<vector<u8>>();
        PathList { paths: v }
    }

    public fun add_path(pl: &mut PathList, path: vector<u8>) {
        vector::push_back(&mut pl.paths, path);
    }

    public fun has_conflict(pl1: &PathList, pl2: &PathList): bool {
        let mut i = 0;
        while (i < vector::length(&pl1.paths)) {
            let p1 = *vector::borrow(&pl1.paths, i);
            let mut j = 0;
            while (j < vector::length(&pl2.paths)) {
                let p2 = *vector::borrow(&pl2.paths, j);
                if (string::equals(&p1, &p2)) {
                    return true;
                };
                j = j + 1;
            };
            i = i + 1;
        };
        false
    }

    public fun runner(): bool {
        let mut pl1 = create_path_list();
        let mut pl2 = create_path_list();

        add_path(&mut pl1, b"/src/module.move");
        add_path(&mut pl1, b"/src/utils.move");

        add_path(&mut pl2, b"/src/dependency.move");
        add_path(&mut pl2, b"/src/utils.move"); // conflict with pl1

        has_conflict(&pl1, &pl2)
    }
}

//# run 0xCAFE::PathConflictDetector::runner

//# publish
module 0xCAFE::SpecAnnotations {
    // Demonstrate Move spec with pragma clauses specifying comma-separated properties
    // Note: This is a conceptual example as Move VM support for pragmas may be limited

    // Spec block with pragma for "invariant, checked"
    #[spec(pragma = "invariant, checked")]
    fun simple_spec(x: u8): bool {
        x < 100
    }

    #[spec(pragma = "verified")]
    fun another_spec(y: u64): bool {
        y != 0
    }

    public fun runner() {
        let _ = simple_spec(42u8);
        let _ = another_spec(7u64);
    }
}

//# run 0xCAFE::SpecAnnotations::runner

//# publish
module 0xCAFE::NativeFuncs {
    use std::signer;
    use std::vector;

    // Declare a native function
    native public fun native_sum(x: u64, y: u64): u64;

    // Implement a wrapper function calling native_sum
    public fun sum_wrapper(x: u64, y: u64): u64 {
        native_sum(x, y)
    }

    public fun runner(): u64 {
        sum_wrapper(10u64, 32u64)
    }
}

//# run 0xCAFE::NativeFuncs::runner

// Featurres:
// 0372a8a2ab875ad7cf0eb89fdc6c264e: Detect when target files and dependency files share the same paths.
// 54aec8a306571d53a83df563ed7c4f5c: Annotate Move spec blocks with 'pragma' clauses specifying comma-separated properties
// c9fa821c04c5061fa871fb56b9e6f584: Define functions (including possibly native functions) in a module.
