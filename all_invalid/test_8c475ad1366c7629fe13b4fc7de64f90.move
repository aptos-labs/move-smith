//# publish
module 0x1::test_module {
    // Function that performs multiple sequential updates on a local variable and sums the result
    public fun accumulate_and_sum(): u64 {
        let mut total = 0;
        let mut local_var = 0;

        // First sequence of updates
        local_var = local_var + 2;
        local_var = local_var + 3;
        total = total + local_var;

        // Reset local variable
        local_var = 0;

        // Second sequence of updates
        local_var = local_var + 5;
        local_var = local_var + 7;
        total = total + local_var;

        // Reset local variable
        local_var = 0;

        // Third sequence of updates
        local_var = local_var + 11;
        local_var = local_var + 13;
        total = total + local_var;

        total
    }
}

//# run 0x1::test_module::accumulate_and_sum
