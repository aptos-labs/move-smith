
//# publish
module 0xCAFE::TestModule {
    struct MyStruct {
        variant_a: u64,
        variant_b: u64,
    }

    public fun initialize_struct(): MyStruct {
        MyStruct {
            variant_a: 0,
            variant_b: 0,
        }
    }

    public fun update_struct(s: &mut MyStruct, val: u64) {
        s.variant_a = val;
        s.variant_b = val + 10;
    }

    public fun get_struct_variants(s: &MyStruct): (u64, u64) {
        (s.variant_a, s.variant_b)
    }

    public fun runner() {
        let s = initialize_struct();
        update_struct(&mut s, 42);
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
        assert!(counter == 5);
    }
}


//# run 0xCAFE::LoopBreakTest::test_loop_break

// Featurres:
// 77353cca0d584cc0d4fa4bec0fc8bf01: This script tests that a loop correctly terminates when the break statement is executed within an if-else structure involving a boolean condition.
// 88c15ed2badc5daf803efcd61e0936a0: Ensure all struct variant names are unique within the same struct.
// 6a625439d3c8b4cd3b0041ba1416e47e: Test that a loop with a break statement correctly updates the variable and executes the assertion.
