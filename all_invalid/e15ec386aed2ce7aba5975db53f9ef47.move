address 0x1 {
    module UnitTest {
        use aptos_framework::account;

        // A simple function that returns the input value incremented by 1
        public fun increment(val: u64): u64 {
            val + 1
        }

        // A function that returns a tuple
        public fun produce_tuple(a: u64, b: bool): (u64, bool) {
            (a, b)
        }

        // A function to test pattern matching with 'except'
        public fun match_except_example(val: u8): bool {
            // Using pattern matching with except is available only in the context of movelang
            // But we simulate usage here in Move style with match and except-like behavior with if-else
            if (val == 0) {
                false
            } else {
                true
            }
        }
    }

    #[test_only]
    module UnitTestTransaction {
        use std::assert;
        use 0x1::UnitTest;

        /// Transactional test function that runs when executing tests
        public entry fun run_test() {
            // Test increment function
            let result = UnitTest::increment(41);
            assert::assert(result == 42, 100);

            // Test produce_tuple function
            let tup = UnitTest::produce_tuple(7, true);
            let (num, flag) = tup;
            assert::assert(num == 7, 101);
            assert::assert(flag == true, 102);

            // Test the match_except_example function for val == 0 and val != 0
            let test_false = UnitTest::match_except_example(0);
            assert::assert(test_false == false, 103);

            let test_true = UnitTest::match_except_example(5);
            assert::assert(test_true == true, 104);
        }
    }
}

// Featurres:
// c4d3be0a8610c7e2a1db729648f6403c: Define a module named 'UnitTest' with the correct address in your Move code to enable testing features.
// 6f73997b889188c622e5ad8254d665d1: Define functions within modules.
// 7a069fb28fcb2dc10abb02c010ad1433: Optionally specify patterns to be excluded with the 'except' keyword.
