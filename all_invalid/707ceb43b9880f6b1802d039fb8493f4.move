
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
        // Tuples are not supported as local variable types, use structs or vectors instead
        // So convert tuple to vector
        let _list2 = vector[4u8, 5u8, 6u8,];
        let _list3 = vector[true, false, true,];
        let _list4 = vector[false, true,];
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
