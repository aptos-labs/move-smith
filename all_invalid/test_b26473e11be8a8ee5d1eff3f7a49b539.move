//# publish
module 0xdeadbeef::sequence_test {
    public fun run_multiple_blocks() {
        let mut total = 0;
        // First anonymous block: initialize and return a value
        {
            let a = 10;
            total = total + a;
        }
        // Second anonymous block: modify total and return
        {
            total = total + 20;
        }
        // Third anonymous block: further modify total
        {
            total = total + 30;
        }
        return total;
    }

    public fun run_vector_mutations() {
        let mut vec = vector[5, 6, 7];
        // Using for_each_mut to double each element
        vector::for_each_mut(&mut vec, |e| { *e = *e * 2 });
        // Validate the mutation (not assertions, just for illustration)
        // Expected vector: [10, 12, 14]
        // In a real test, you might assert, but per instructions, assertions are optional.
        return;
    }

    public fun sequence_runner() {
        let result = Self::run_multiple_blocks();
        // Store or use result for verification if needed
        // For this test, just leaving it to execute sequence correctly
        return;
    }

    public fun vector_mutation_runner() {
        Self::run_vector_mutations();
        return;
    }
}

//# run 0xdeadbeef::sequence_test::sequence_runner
//# run 0xdeadbeef::sequence_test::vector_mutation_runner