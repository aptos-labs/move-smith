
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_u8_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = sum + 10u8; // Add 10 to test computation
        result
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let summed = add_lambda(x, y);
        summed
    }
}


//# run 0xCAFE::ComputeAdd::add_u8_then_return --args 5u8 7u8


//# run 0xCAFE::ComputeAdd::use_lambda --args 12u8 8u8


//# publish
module 0xBEEF::UseInline {
    use 0xCAFE::ComputeAdd;

    public inline fun double_inline_add(a: u8, b: u8): u8 {
        let sum = ComputeAdd::add_u8_then_return(a, b);
        let doubled = sum * 2u8;
        doubled
    }

    public fun run_double_add(): u8 {
        double_inline_add(3u8, 4u8)
    }
}


//# run 0xBEEF::UseInline::run_double_add


//# publish
module 0xCAFE::LoopBreakTest {
    public fun check_break_behavior(x: u8): u8 {
        let counter = x;
        loop {
            if (counter > 0) {
                counter = counter - 1;
            } else {
                break;
            };
        };
        counter
    }
}


//# run 0xCAFE::LoopBreakTest::check_break_behavior --args 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e6f30b85424e139c306d6bec24378617: Refer to Move modules either by their named address or by their numerical (hex) address in module identifiers.
// d3f8a0277ce5c8e6a0232a5159bbc73f: Ensure address names are either anonymous or restricted to valid naming conventions.
// f1b503924389332f92227a5949789ee1: Test that a `loop break` statement is valid and executes correctly even when not nested inside an explicit loop.
