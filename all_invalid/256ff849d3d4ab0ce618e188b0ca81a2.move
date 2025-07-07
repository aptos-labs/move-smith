
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // Function to test parameter separation and diagnostics ordering
    public fun test_parameter_separation(a: u8, b: u16, c: bool) {
        // All parameters separated by commas; no error expected here
        assert!(a != 0, 100);
        assert!(b > 0, 101);
        if (c) {
            assert!(c, 102);
        } else {
            assert!(!c, 103);
        };
    }

    // Function to test diagnostics report sorting by primary location
    public fun report_diagnostics() {
        // Introduce deliberate errors:
        // 1. Call a non-existent function to trigger an error
        // 2. Call a function with wrong argument types
        // 3. Pass a vector where a u8 is expected
        // 4. Use an unknown variable
        // These errors should be reported with sorted primary locations

        // Error 1: non-existent function
        let _ = non_existent_function();

        // Error 2: wrong argument types
        let v: vector<u8> = vector::empty<u8>();
        let _ = test_parameter_separation(1u8, v, true); // v passed where u16 expected

        // Error 3: passing vector as argument where u8 expected
        let _ = test_parameter_separation(vector::pop_back(&v), 5u16, true);

        // Error 4: use of unknown variable
        let _ = unknown_variable + 1;
    }

    // Function to test reporting intersection of target and dependency files
    public fun check_target_dep_intersection() {
        // Define arbitrary file paths
        let target_files = vector::singleton(x"src/file1.move");
        let dep_files = vector::singleton(x"src/file1.move");

        // Detect intersection (simulate by comparing vectors)
        let intersection_found = false;

        let i = 0;
        while (i < vector::length(&target_files)) {
            let target_file = *vector::borrow(&target_files, i);
            let j = 0;
            while (j < vector::length(&dep_files)) {
                let dep_file = *vector::borrow(&dep_files, j);
                if (target_file == dep_file) {
                    intersection_found = true;
                };
                let j = j + 1;
            };
            let i = i + 1;
        };

        // Error report if intersection exists
        if (intersection_found) {
            // List all files involved that are targets and dependencies
            let all_targets = target_files;
            let all_dependencies = dep_files;
            // Emit an error message listing the files
            // Since Move does not have a print, simulate with a failing assertion
            assert!(false, 999, "Error: Files intersect as targets and dependencies. Target files: {:?}, Dependency files: {:?}", all_targets, all_dependencies);
        } else {
            // No intersection, pass silently
            assert!(true, 0);
        };
    }
}


//# run 0xCAFE::FeatureTest::report_diagnostics

// Featurres:
// cd6efccaaa22ee0f4bc4a974802d383c: Specify function parameters separated by commas within parentheses.
// d841ea59cfe5c6ef8cd86075c88d17d4: Sort diagnostics report entries by their primary location to organize error messages.
// 56ef38758ed60a50088ec4925667996a: Report an error listing all files that are marked as both targets and dependencies when intersection occurs.
