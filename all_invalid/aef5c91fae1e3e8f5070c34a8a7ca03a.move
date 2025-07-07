
//# publish
module 0xDEAD::TestVectors {
    use std::vector;
    use std::assert;

    // Function that returns a vector constructed explicitly with push_back
    public fun explicit_vector() acquires vector {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 0x12u8);
        vector::push_back(&mut v, 0x34u8);
        vector::push_back(&mut v, 0x56u8);
        v
    }

    // Function that returns a vector using hexadecimal byte string notation
    public fun hex_vector() acquires vector {
        let v = x"123456" /* This creates a vector<u8> with bytes 0x12, 0x34, 0x56 */;
        v
    }

    // Function to verify that both vectors are equal element-wise
    public fun verify_vectors_equality() acquires vector {
        let v1 = explicit_vector();
        let v2 = hex_vector();

        let len_v1 = vector::length(&v1);
        let len_v2 = vector::length(&v2);
        assert!(len_v1 == len_v2, 100);

        let i = 0;
        while (i < len_v1) {
            let a = *vector::borrow(&v1, i);
            let b = *vector::borrow(&v2, i);
            assert!(a == b, 101);
            i = i + 1;
        };
        // return true explicitly to confirm check passed
        true
    }

    // Helper function that applies a vector of functions (closures) to an input and sums their results
    public fun eval(funcs: vector<|u8|u8>, input: u8): u8 {
        let len = vector::length(&funcs);
        let sum = 0u8;
        let i = 0;
        while (i < len) {
            let func = *vector::borrow(&funcs, i);
            let res = func(input);
            sum = sum + res;
            i = i + 1;
        };
        // return sum as last expression
        sum
    }

    // Sample functions to apply
    public fun add_one(x: u8): u8 {
        x + 1
    }

    public fun double(x: u8): u8 {
        x * 2
    }

    public fun square(x: u8): u8 {
        x * x
    }

    // Runner function to test eval with multiple functions
    public fun run_eval_test(): u8 {
        let funcs = vector::empty<|u8|u8>();
        vector::push_back(&mut funcs, add_one);
        vector::push_back(&mut funcs, double);
        vector::push_back(&mut funcs, square);
        let input_value = 3u8;
        eval(funcs, input_value)
    }

    // Optional: main verification
    public fun verify_all() {
        verify_vectors_equality();
        let result = run_eval_test();
        // for example, with input 3:
        // add_one(3) = 4
        // double(3) = 6
        // square(3) = 9
        // total = 4 + 6 + 9 = 19
        assert!(result == 19, 102);
        true
    }
}


//# run 0xDEAD::TestVectors::verify_all


// Featurres:
// fafe4dcac2529477f68e855042041585: Test that both explicit vector construction and hexadecimal byte string notation produce equivalent byte vectors and allow correct element indexing.
// 1f8caf0229b4f4e45239ffff6f3cba57: Test that the `eval` function correctly computes the sum of applying the generated vector of functions to the input argument.
// bb9fae4aff8bda84cdc6b8b4a25bc3c2: Use return statements in expressions
