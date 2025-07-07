// # publish
module 0xCAFE::ListParsingTests {
    use std::option;
    use std::vector;

    #[test]
    public fun test_optional_whitespace_and_tokens() {
        // Test vector creation with various whitespace and commas including trailing comma
        let v1 = vector[1, 2 ,3,4 ,5 , ]; // with optional spaces and trailing comma
        let expected = vector[1, 2, 3, 4, 5];
        assert(vector::length(&v1) == vector::length(&expected), 42);
        let mut i = 0;
        while (i < vector::length(&v1)) {
            assert(*vector::borrow(&v1, i) == *vector::borrow(&expected, i), 43);
            i = i + 1;
        }

        // Test option vector with optional whitespace
        let vo1 = some<vector<u8>>(vector[10, 20 , 30 , ]);
        let vo2 = some<vector<u8>>(vector[10, 20, 30]);
        assert(option::is_some(&vo1), 44);
        assert(option::is_some(&vo2), 45);
        let v1 = option::borrow(&vo1);
        let v2 = option::borrow(&vo2);
        let len1 = vector::length(v1);
        let len2 = vector::length(v2);
        assert(len1 == len2, 46);
        let mut j = 0;
        while (j < len1) {
            assert(*vector::borrow(v1, j) == *vector::borrow(v2, j), 47);
            j = j + 1;
        }
    }

    // A function testing mutable references and their behavior
    public fun test_mutable_references() {
        let mut x = 5u64;
        let x_ref = &mut x;
        *x_ref = 10u64;
        assert(x == 10u64, 48);

        // Create a vector and mutate an element via mutable reference
        let mut v = vector[1u64, 2u64, 3u64];
        let elem_ref = &mut *vector::borrow_mut(&mut v, 1);
        *elem_ref = 42u64;
        assert(*vector::borrow(&v, 1) == 42u64, 49);
    }

    // Runner function without arguments for test framework
    public fun run_all_tests() {
        test_optional_whitespace_and_tokens();
        test_mutable_references();
    }
}
// # run 0xCAFE::ListParsingTests::run_all_tests --signers 0xCAFE

// # publish
#[test]
module 0xCAFE::TestAttributeUsage {
    #[test]
    public fun sample_test() {
        assert(true, 1);
        let mut x = 1u8;
        assert(x == 1u8, 2);
    }

    #[test]
    public fun sample_test_mut_ref() {
        let mut y = 100u64;
        let y_mut_ref = &mut y;
        *y_mut_ref = 200u64;
        assert(y == 200u64, 3);
    }
}
// # run 0xCAFE::TestAttributeUsage::sample_test --signers 0xCAFE
// # run 0xCAFE::TestAttributeUsage::sample_test_mut_ref --signers 0xCAFE

// # run
script {
    use 0xCAFE::ListParsingTests;
    use std::debug;

    fun main() {
        ListParsingTests::run_all_tests();
        debug::print(b"Completed all ListParsingTests\n");
    }
}

// Featurres:
// d1339eed7d8e3ec9b914dc7fc9c593b0: Handle optional whitespace and tokens within list parsing.
// 9813d01e7c0cc1c0e64383ab4f725517: Use test attributes with the syntax `#[test]` in Move code to mark test functions or modules.
// 75e91ea29526c106545f5899d508c944: Create mutable references to values using the &mut operator.
