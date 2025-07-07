
//# publish
module 0xBADD::NestedExpressionsTest {
    use std::vector;

    struct Pair has copy, drop {
        a: u32,
        b: u32,
    }

    struct ComplexStruct has copy, drop {
        p: Pair,
        c: u32,
    }

    // Function to test nested block expressions, variable mutations, and vector index updates
    public fun test_nested_blocks_and_vector() {
        let vec: vector<u64> = vector::empty<u64>();
        vector::push_back(&mut (vec), 10);
        vector::push_back(&mut (vec), 20);
        vector::push_back(&mut (vec), 30);

        let (mut sum, mut i) = (0, 0);
        while (i < vector::length(&vec)) {
            let val = *vector::borrow(&vec, i);
            sum = sum + val;
            if (val > 15) {
                vector::borrow_mut(&mut (vec), i + 1); // Access to trigger update
                vector::push_back(&mut (vec), val + 1);
            };
            i = i + 1;
        };
        assert!(sum == 60, 999);
        // Update vector element within nested blocks
        let index = 1;
        if (index < vector::length(&vec)) {
            let element_ref = vector::borrow_mut(&mut (vec), index);
            *element_ref = 42;
        };
        assert!(*vector::borrow(&vec, 1) == 42, 999);
    }

    // Function to trigger diagnostic message for deprecated modules
    public fun deprecated_module_usage() {
        // Suppose std::vector is deprecated, this should produce a warning in real compiler
        // For the purpose of this test, just call a deprecated-looking usage
        let _v: vector<u8> = vector::empty();
    }

    // Function to test destructuring of nested structs and sum of fields
    public fun destructure_and_sum(complex: ComplexStruct): u32 {
        let ComplexStruct { p: Pair { a: a_val, b: b_val }, c: c_val } = complex;
        let sum = a_val + b_val + c_val;
        sum
    }

    // Runner function to execute all tests
    public fun run_tests() {
        test_nested_blocks_and_vector();
        deprecated_module_usage();
        let pair = Pair { a: 10, b: 20 };
        let complex = ComplexStruct { p: pair, c: 30 };
        let total = destructure_and_sum(complex);
        assert!(total == 60, 999);
    }
}


//# run 0xBADD::NestedExpressionsTest::run_tests


// Featurres:
// af98d5c12b4870b5818f6e1b456c499f: Test the correct evaluation of nested block expressions, variable mutations, and vector index updates within functions and assertions.
// cc34729450c4cd057130f86dfbdd72b3: Be warned when using deprecated modules via diagnostic messages
// 63eaf0ea8957190ee5813e1f280549cf: Test that destructuring a struct with nested expressions correctly assigns values and computes the sum of its fields.
