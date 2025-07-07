//# publish
module 0x100::NestedInlineTestModule {
    public inline fun multiply_by_two(x: u64): u64 {
        x * 2
    }

    public inline fun add_three(y: u64): u64 {
        y + 3
    }
}

//# publish
module 0x100::NestedInlineTestMain {
    use 0x100::NestedInlineTestModule;

    // Define a function that combines nested inline function calls
    fun compute_combined_value(val: u64): u64 {
        // Call multiply_by_two on val, then add_three to the result
        add_three(NestedInlineTestModule::multiply_by_two(val))
    }

    public fun run_computation(): u64 {
        compute_combined_value(7)
    }
}

//# run 0x100::NestedInlineTestMain::run_computation