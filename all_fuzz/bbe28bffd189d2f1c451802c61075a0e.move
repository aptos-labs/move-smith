
//# publish
module 0xCAFE::AddTest {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        assert!(sum <= 255, 1); // Just a check, always true for u8 sum
        sum
    }
}


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::AddTest;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AddTest::add_then_return_sum(a, b)
    }

    public fun perform_nested_call(): u8 {
        let temp = inline_add(10u8, 20u8);
        perform_add(temp, 5u8)
    }

    public fun perform_add(x: u8, y: u8): u8 {
        x + y
    }
}


//# run 0xCAFE::AddTest::add_then_return_sum --args 100u8 23u8


//# run 0xCAFE::NestedCallTest::perform_nested_call

// Attribute on address block example:
// The following address block has a comment attribute for demonstration:
// @notice This address block is for testing attribute usage.
address 0xCAFE {
    // Dummy function inside address block to exercise attribute usage.
    public fun dummy() {
        // do nothing
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 418d21af27824d7d28f4fb5f19bde171: Use attributes on address blocks to annotate them.
