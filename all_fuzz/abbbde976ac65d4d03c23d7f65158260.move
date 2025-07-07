
//# publish
module 0xCAFE::Computation {
    /// Simple function that adds two u8 values and then returns 42.
    public fun add_and_return_42(x: u8, y: u8): u8 {
        let _sum = x + y;
        // Return the constant 42, ignoring sum (but sum computed)
        42u8
    }

    /// Function that contains a lambda (anonymous function) that doubles a u8.
    public fun double_with_lambda(x: u8): u8 {
        let doubler: |u8| u8 has copy + drop = |a: u8| {
            a * 2
        };
        doubler(x)
    }

    /// Inline function that multiplies a u8 by 3.
    public inline fun triple(x: u8): u8 {
        x * 3
    }
}



//# publish
module 0xCAFE::Nesting {
    use 0xCAFE::Computation;

    /// Calls the inline triple function from Computation and doubles the result 
    /// by calling another function.
    public fun nested_compute(x: u8): u8 {
        let tripled = Computation::triple(x);
        let doubler: |u8| u8 has copy + drop = |val: u8| {
            val * 2
        };
        let doubled = doubler(tripled);
        doubled
    }
}



//# publish
module 0xCAFE::DebugUtil {
    /// Returns a vector of bytes representing the raw names of local variables
    /// live at the provided code offset.
    /// This is a dummy impl for demonstration, returning a fixed vector since
    /// raw debug info is not accessible directly in Move.
    public fun get_live_locals_raw_names(_code_offset: u64): vector<u8> {
        // Represent variable names as byte string "x,y,z"
        b"x,y,z"
    }
}



//# publish
module 0xCAFE::ReturnTest {
    /// Function that returns early with a return expression without a value.
    public fun return_early_no_value(x: u8): u8 {
        if (x > 10) {
            return 0u8;
        };
        // If no early return happened, return x
        x
    }

    /// Function that returns early with a return expression with a value.
    public fun return_early_with_value(x: u8): u8 {
        if (x > 10) {
            return 99u8;
        };
        // If no early return happened, return x
        x
    }
}



//# run 0xCAFE::Computation::add_and_return_42 --args 10u8 20u8



//# run 0xCAFE::Computation::double_with_lambda --args 21u8



//# run 0xCAFE::Nesting::nested_compute --args 5u8



//# run 0xCAFE::DebugUtil::get_live_locals_raw_names --args 0u64



//# run 0xCAFE::ReturnTest::return_early_no_value --args 5u8



//# run 0xCAFE::ReturnTest::return_early_no_value --args 20u8



//# run 0xCAFE::ReturnTest::return_early_with_value --args 5u8



//# run 0xCAFE::ReturnTest::return_early_with_value --args 20u8
