
//# publish
module 0xCAFE::AdvancedMath {
    /// Returns the sum of a and b plus a fixed offset 5
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    /// Returns a lambda that adds 10 to its input
    public fun make_adder(): |u8|u8 {
        |x: u8| {
            x + 10
        }
    }

    /// Applies a given lambda to the number 20
    public fun apply_lambda(f: |u8|u8): u8 {
        f(20)
    }
}




//# run 0xCAFE::AdvancedMath::add_with_offset --args 3u8 7u8

// Fix here: cannot pass a lambda-type argument via --args, so instead run make_adder alone (no args)



//# run 0xCAFE::AdvancedMath::make_adder


// Fix here: Cannot pass the lambda returned by make_adder as a function argument via CLI directly
// Instead, use hardcoded examples or nested calls in Move code.
// So remove this run line that tries passing 0xCAFE::AdvancedMath::make_adder as an arg

// # Removed:
// 
// # run 0xCAFE::AdvancedMath::apply_lambda --args 0xCAFE::AdvancedMath::make_adder




//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AdvancedMath;

    /// Calls AdvancedMath::add_with_offset and adds 1 more to the result
    public fun nested_add(a: u8, b: u8): u8 {
        let base = AdvancedMath::add_with_offset(a, b);
        base + 1
    }

    /// Calls AdvancedMath::apply_lambda with a lambda that doubles its input
    public fun nested_apply_lambda(): u8 {
        let lambda: |u8| u8 = |x: u8| { x * 2 };
        AdvancedMath::apply_lambda(lambda)
    }

    /// Calls AdvancedMath::make_adder, then applies the returned lambda to 5
    public fun nested_make_and_apply(): u8 {
        let adder = AdvancedMath::make_adder();
        adder(5)
    }
}




//# run 0xCAFE::NestedCalls::nested_add --args 4u8 6u8




//# run 0xCAFE::NestedCalls::nested_apply_lambda




//# run 0xCAFE::NestedCalls::nested_make_and_apply
