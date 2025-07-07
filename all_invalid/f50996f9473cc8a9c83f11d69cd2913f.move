// Transactional test case for Aptos Move compiler and VM

address 0x1 {
module TestTransaction {

    use Std::Vector;
    use Std::Debug as Dbg;
    use Std;

    // 1. Test function to simulate an error when a file is marked both as a target and a dependency
    fun test_duplicate_file_marking_error() {
        // Simulated file lists
        let targets = Vector::empty<string>();
        let dependencies = Vector::empty<string>();

        // Helper to add file names
        let add_file = |vec: &mut vector<string>, name: string| {
            Vector::push_back(vec, name);
        };

        // Populating targets and dependencies with some overlap
        add_file(&mut targets, b"file_a.move".to_string());
        add_file(&mut targets, b"file_b.move".to_string());
        add_file(&mut targets, b"file_c.move".to_string());

        add_file(&mut dependencies, b"file_x.move".to_string());
        add_file(&mut dependencies, b"file_b.move".to_string());
        add_file(&mut dependencies, b"file_c.move".to_string());

        // Detect intersection
        let mut intersection = Vector::empty<string>();
        let target_len = Vector::length(&targets);
        let dep_len = Vector::length(&dependencies);

        let i = 0;
        while (i < target_len) {
            let target_file = *Vector::borrow(&targets, i);
            let j = 0;
            while (j < dep_len) {
                let dep_file = *Vector::borrow(&dependencies, j);
                if (target_file == dep_file) {
                    Vector::push_back(&mut intersection, target_file);
                }
                j = j + 1;
            }
            i = i + 1;
        }

        // Check if intersection is non-empty and report error
        if (Vector::length(&intersection) > 0) {
            // Create error message string
            let mut msg = b"Error: The following files are marked as both targets and dependencies: ".to_string();
            let len = Vector::length(&intersection);
            let mut k = 0;
            while (k < len) {
                let file = *Vector::borrow(&intersection, k);
                msg = Vector::concat(msg, file);
                if (k < len - 1) {
                    msg = Vector::concat(msg, b", ".to_string());
                }
                k = k + 1;
            }
            // Abort with error
            abort_with_message(1, &msg);
        }
    }

    // 2. Define a module with inline and non-inline functions to test inline accessibility
    module InlineTest {
        public inline fun accessible_inline(): u64 {
            42
        }

        friend fun inaccessible_inline(): u64 {
            100
        }

        // Non-inline function
        public fun non_inline(): u64 {
            200
        }
    }

    // 2. Test case ensuring only accessible inline functions can be called before inlining
    fun test_inline_functions_accessibility() acquires TestTransaction {
        // Allowed to call public inline
        let val1 = InlineTest::accessible_inline();

        // Should not be allowed to call inaccessible inline function - this line
        // if uncommented, should cause a compile error:
        // let val2 = InlineTest::inaccessible_inline();

        // Allowed to call public non-inline function normally
        let val3 = InlineTest::non_inline();

        // Use debug assert to check values (ensures functions are callable where allowed)
        Dbg::print(&val1);
        Dbg::print(&val3);
    }

    // 3. Test using 'use' declarations with and without aliasing
    fun test_use_declarations() {
        // Using original module Std::Debug
        Std::Debug::print(&42);

        // Using alias Dbg for Std::Debug
        Dbg::print(&43);
    }

    // Utility abort with message function - standard pattern in move
    native fun abort(code: u64);

    fun abort_with_message(code: u64, msg: &vector<u8>) {
        // Print message before abort
        Std::Debug::print(msg);
        abort(code)
    }

    #[test]
    public fun run_all_tests() {
        test_duplicate_file_marking_error();

        test_inline_functions_accessibility();

        test_use_declarations();
    }
}}

// Featurres:
// 56ef38758ed60a50088ec4925667996a: Report an error listing all files that are marked as both targets and dependencies when intersection occurs.
// 0331f48fa3a869adb5cce5f5a20ba73b: Ensure that only accessible inline functions can be called before inlining.
// ce8f445c59f9734a04ad03d5decde9da: Use 'use' declarations to import entire modules with optional aliasing.
