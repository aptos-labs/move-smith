
//# publish
module 0xCAFE::nested_blocks_and_refs {
    use std::vector;

    // Function to test nested block expressions, variable mutations, and vector index updates
    public fun nested_eval(vec: &mut vector<u64>): u64 {
        let result;
        // outer block
        {
            let temp = 0;
            // inner block 1
            {
                let inner_var = 10;
                // mutate inner_var
                inner_var = inner_var + 5;
                // update vector at index 0
                vector::borrow_mut(vec, 0) = inner_var;
                temp = inner_var * 2;
            }

            // inner block 2
            {
                let inner_ref = &temp; // immutable reference
                let inner_ref2 = &temp; // another immutable ref
                // use both refs in expression
                result = *inner_ref + *inner_ref2 + temp;
            }
        }
        result
    }

    // Inline version of specification function (can be inlined)
    public inline fun inline_specification(val: u64): bool {
        // simple condition for inlining
        val > 10
    }

    // Non-inlined version of specification function
    public fun non_inline_specification(val: u64): bool {
        val > 10
    }

    // Function that uses both spec functions
    public fun test_specifications(val1: u64, val2: u64): bool {
        inline_specification(val1) && non_inline_specification(val2)
    }
}


//# run 0xCAFE::nested_blocks_and_refs::nested_eval --signers 0xBEEF


//# run 0xCAFE::nested_blocks_and_refs::test_specifications --signers 0xBEEF --args 12u64 15u64