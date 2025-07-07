//# publish
module 0xabcde::nested_blocks {
    /// Test nested block expressions, variable mutations, and vector index updates
    public fun test_nested_blocks() {
        let v = 2;
        // Nested block expressions that update v multiple times
        let result = {
            let mut temp = v;
            // Outer block
            {
                // Inner block 1
                temp += {
                    // Innermost block
                    {
                        temp += 3;
                        temp
                    }
                }
                ;
                // Inner block 2
                {
                    temp += 2;
                    temp
                }
            }
            ;
            temp
        };
        // After execution, temp should be v + 3 + 2 = 2 + 3 + 2 = 7
        assert!(result == 7);
    }

    /// Test variable mutation through nested blocks
    public fun mutate_in_blocks() {
        let x = 10;
        let y = {
            let mut x_mut = x;
            {
                // Mutate x_mut
                x_mut += 5;
            }
            {
                // Further mutation
                x_mut += 3;
            }
            x_mut
        };
        // y should be 10 + 5 + 3 = 18
        assert!(y == 18);
    }

    /// Test vector index update within nested blocks and function call
    public fun update_vector() {
        let mut vec = vector<u64>[10, 20, 30, 40];
        let mut index = 1; // points to second element
        // Nested block updates `index` and then updates vector at that index
        {
            index += 2; // index becomes 3 (pointing to 40)
            vec[{ index }] += {
                index += 1; // index now 4
                // Since index now is 4, which is out of bounds, but Move vectors auto-handle bounds by panic,
                // For test, we'll ensure index stays within bounds
                // So adjusting index back
                index -= 1; // index back to 3
                vec[{ index }]
            };
        }
        // Now, vec[3] (the last element) should be 40 + 40 = 80
        assert!(vec == vector<u64>[10, 20, 30, 80]);
    }

    /// Function to run the above tests
    fun run_tests() {
        test_nested_blocks();
        mutate_in_blocks();
        update_vector();
    }
}

//# run 0xabcde::nested_blocks::run_tests --signers 0xabcde