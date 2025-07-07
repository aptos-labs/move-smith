
//# publish
module 0xCAFE::AdditionModule {
    /// Simple struct with u8 fields
    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    /// Adds two u8 numbers and returns sum + 2
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 2
    }

    /// Defines and uses a lambda to add two numbers and multiply by 2
    public fun lambda_test(): u8 {
        let add_and_double: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            let s = x + y;
            s * 2
        };
        add_and_double(3u8, 4u8)
    }
}



//# run 0xCAFE::AdditionModule::add_and_offset --args 10u8 15u8



//# run 0xCAFE::AdditionModule::lambda_test




//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::AdditionModule;

    /// Calls AdditionModule::add_and_offset inline and returns the result doubled
    public fun call_add_and_double(a: u8, b: u8): u8 {
        let result = AdditionModule::add_and_offset(a, b);
        result * 2
    }
}



//# run 0xCAFE::InlineCall::call_add_and_double --args 3u8 7u8




//# publish
module 0xCAFE::StructAndVariantModule {
    /// Singleton struct (single field)
    struct Wrapper has copy, drop, store {
        val: u64
    }

    /// Variant enum with variants and associated data
    enum Choice has copy, drop {
        None,
        Number(u8),
        Pair { x: u8, y: u8 }
    }

    /// Creates a Wrapper
    public fun make_wrapper(): Wrapper {
        Wrapper { val: 1000u64 }
    }

    /// Creates Choice::Pair variant
    public fun make_pair(): Choice {
        Choice::Pair { x: 5u8, y: 10u8 }
    }
}



//# run 0xCAFE::StructAndVariantModule::make_wrapper



//# run 0xCAFE::StructAndVariantModule::make_pair




    use 0xCAFE::AdditionModule;

    entry fun add_two_values(a: u8, b: u8): u8 {
        AdditionModule::add_and_offset(a, b)
    }
}



//# run --args 20u8 22u8
