address 0x1 {
    module CompilerVmTest {
        use std::version;
        use std::debug;

        /// Helper function to check Move version at runtime.
        /// Requires Move version >= 6 for this test (example version).
        fun assert_minimum_version() acquires VersionInfo {
            let current_version = version::get_move_version();
            let required_version = 6u64;
            debug::assert!(current_version >= required_version, 100, "Move version too low");
        }

        /// Test entry function using `entry` modifier.
        #[test] // This annotation is used by the test framework to discover test functions.
        entry fun test_entry_function() {
            assert_minimum_version();
            // Perform a simple state-modifying operation or logic.
            let x = 2 + 3;
            debug::assert!(x == 5, 101, "Addition failed");
        }

        /// Test function with deprecated visibility `script` to verify backward compatibility.
        #[test]
        public(script) fun test_script_visibility() {
            assert_minimum_version();
            let y = 10 * 2;
            debug::assert!(y == 20, 102, "Multiplication failed");
        }

        /// Test filtering of functions by name prefix 'filter_test_members'
        /// Only functions with names starting with `filter_test_members` are considered.
        #[test]
        entry fun filter_test_members_addition() {
            assert_minimum_version();
            let a = 7;
            let b = 8;
            let c = a + b;
            debug::assert!(c == 15, 103, "Addition does not match expected value");
        }

        #[test]
        entry fun filter_test_members_subtraction() {
            assert_minimum_version();
            let a = 20;
            let b = 5;
            let c = a - b;
            debug::assert!(c == 15, 104, "Subtraction does not match expected value");
        }

        /// This test should NOT be filtered in by 'filter_test_members' filter due to name.
        #[test]
        entry fun another_test_function() {
            assert_minimum_version();
            let flag = true;
            debug::assert!(flag, 105, "Boolean flag failed");
        }
    }
}

// Featurres:
// 7adce3d4b2624780062b8f23dc554916: Use unit testing features via functions filtered by 'filter_test_members'.
// 92c46e3e4f1eaab7b786e011f2d5bbde: Mark functions as entry points using the 'entry' modifier or deprecated script visibility.
// 28df48782a29a78c04bbccf99d0e5ae8: Require the Move version to meet a minimum specified version.
