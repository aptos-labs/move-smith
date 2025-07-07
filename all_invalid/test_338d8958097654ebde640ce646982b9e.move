//# publish
module 0x1::TestNestedLoops {
    //# publish
    // Test nested loops with break statements exiting inner loops and updating variables
    public fun test_nested_breaks() {
        let mut outer_var = 0;
        let mut inner_var = 0;

        let mut i = 0;
        while (i < 3) {
            let mut j = 0;
            loop {
                if (j == 2) {
                    break;
                }
                inner_var = j;
                j = j + 1;
            };
            outer_var = i;
            if (outer_var == 1) {
                break;
            }
            i = i + 1;
        };
        assert!(outer_var == 1, 42);
        assert!(inner_var == 1, 42);
    }

    //# run
    // Execute the nested loops test
    fun main() {
        test_nested_breaks();
    }
}

 //# publish
module 0x2::TestConditional {
    //# run
    // Test conditional execution paths with both branches returning successfully
    public fun test_conditional_branch(condition: bool) {
        if (condition) {
            return;
        } else {
            return;
        }
    }

    //# run 0x2::TestConditional::test_conditional_branch --args true
    //# run 0x2::TestConditional::test_conditional_branch --args false
}

 //# publish
module 0x3::TestInlineFunction {
    //# run
    // Test invoking an inline function with multiple arguments and a function pointer
    inline fun compute_sum(g: |u64, u64, u64| u64, a: u64, b: u64, c: u64): u64 {
        g(a, b, c)
    }

    public fun test() {
        let result = compute_sum(|x: u64, y: u64, z: u64| { x + y + z },
            5, 15, 25);
        assert!(result == 45, 42);
    }

    //# run 0x3::TestInlineFunction::test
}