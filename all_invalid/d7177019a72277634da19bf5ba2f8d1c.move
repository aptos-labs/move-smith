address 0x1 {
    module Test {
        // 1. Define a generic struct with a type parameter
        struct Wrapper<T> has copy, drop, store {
            value: T,
        }

        // 2. Attach an attribute to a function
        #[test]
        public fun test_wrapper_assertion<T>(value: T) acquires Wrapper<T> {
            // Create a Wrapper<T>
            let wrapped = Wrapper<T> { value };

            // 3. Use assert to validate that wrapped.value equals the input value
            // Note: We can only assert basic conditions; here we check non-null by assuming T is bool or u64 in tests
            assert!(wrapped.value == value, 1);

            // Additional assertion example:
            // For the purpose of illustration, if T is u64, assert it is not zero
            // Using a dummy condition with trait bound is not supported, so we simulate integer tests below

            // TODO: Move lacks reflection; we test in concrete instances below
        }

        // 4. Another function with assert and attribute on a struct declaration

        #[test]
        struct AssertedPair<T has copy + drop + store, U has copy + drop + store> has copy, drop, store {
            x: T,
            y: U,
        }

        #[test]
        public fun test_asserted_pair<T has copy + drop + store, U has copy + drop + store>(x: T, y: U) acquires AssertedPair<T, U> {
            let pair = AssertedPair<T, U> { x, y };
            // Assert something trivial but true
            assert!(pair.x == x, 2);
            assert!(pair.y == y, 3);
        }
    }
}

// -------------------------------------------
// Transactional test script in Move language
// Demonstrates calling generic test functions with concrete types
// -------------------------------------------
script {
    use 0x1::Test;

    fun main() {
        // Testing test_wrapper_assertion with u64 (integer)
        // Should pass, value = 42
        Test.test_wrapper_assertion<u64>(42);

        // Testing test_wrapper_assertion with bool
        Test.test_wrapper_assertion<bool>(true);

        // Testing test_asserted_pair with (u64, bool)
        Test.test_asserted_pair<u64, bool>(10, false);

        // Testing test_asserted_pair with (bool, bool)
        Test.test_asserted_pair<bool, bool>(true, true);
    }
}

// Featurres:
// 5e0902799ab755c35a5cabcf13775d0a: Write 'assert' specifications in Move code to add conditions that must hold at a point.
// 7b8172797b973455b7119c42abf5a4df: Attach attributes to Move declarations by specifying an attribute name.
// e731d714e7696e38c4992a86138da242: Define struct type parameters for generic types.
