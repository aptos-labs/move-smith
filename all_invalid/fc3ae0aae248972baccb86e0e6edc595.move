
//# publish
module 0xCAFE::TestModule {
    struct MyStruct (variant_a: u64, variant_b: u64) {
        // no fields to be added
    }

    public fun initialize_struct(): MyStruct {
        MyStruct { variant_a: 0, variant_b: 0 }
    }

    public fun update_struct(s: &mut MyStruct, val: u64) {
        s.variant_a = val;
        s.variant_b = val + 10;
    }

    public fun get_struct_variants(s: &MyStruct): (u64, u64) {
        (s.variant_a, s.variant_b)
    }

    public fun runner() {
        // Use a local variable that is dropped after the function ends
        let s = initialize_struct();
        update_struct(&mut s, 42);
        // Optionally, get the variants to avoid unused variable warning
        let _variants = get_struct_variants(&s);
    }
}



//# run 0xCAFE::TestModule::runner



//# publish
module 0xCAFE::LoopBreakTest {
    public fun test_loop_break() {
        let counter = 0;
        let limit = 5;

        while (true) {
            if (counter >= limit) {
                break;
            } else {
                counter = counter + 1;
            }
        }
        // Move 'counter' to a local variable for assertion
        let c = counter;
        assert!(c == 5);
    }
}



//# run 0xCAFE::LoopBreakTest::test_loop_break