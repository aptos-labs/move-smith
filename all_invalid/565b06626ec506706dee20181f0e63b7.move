
//# publish
module 0xCAFE::NestedInline {
    public inline fun add_one(a: u64): u64 {
        a + 1
    }

    public inline fun add_two(a: u64): u64 {
        let b = add_one(a);
        add_one(b)
    }

    public fun compute(x: u64): u64 {
        // test calling nested inline functions, should add 2 to x
        add_two(x)
    }

    public fun test_comma_parsing() {
        // Parse comma-separated lists with optional trailing commas:
        let _list1 = vector[1u8, 2u8, 3u8,];
        let _list2 = (4u8, 5u8, 6u8,);
        let _list3 = vector[true, false, true,];
        let _list4 = (false, true,);
    }

    public fun test_early_return(x: bool) {
        if (x) {
            return;
        };
        // this assertion should be bypassed if x is true
        assert!(false, 999);
    }
}


//# run 0xCAFE::NestedInline::compute --args 10u64


//# run 0xCAFE::NestedInline::test_comma_parsing


//# run 0xCAFE::NestedInline::test_early_return --args true


//# run 0xCAFE::NestedInline::test_early_return --args false


// Featurres:
// e6c9221ab82795e73d9565f626f89a59: Test that calling nested inline functions from a module correctly computes the expected result when invoked through the main function.
// fff6da1af7f2555582182f8da47ddb58: Parse comma-separated lists of syntax elements with optional trailing commas.
// c971a0637cbb2005d5f215c962d97fe5: Test that the script returns early when the condition is true, preventing the assertion from executing.
