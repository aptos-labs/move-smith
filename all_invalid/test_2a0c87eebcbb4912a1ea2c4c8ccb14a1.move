//# publish
module 0xA11E::NestedFunctions {
    public inline fun apply(f: |u64, u64|u64, x: u64, y: u64): u64 {
        f(x, y)
    }

    public fun multiply(x: u64, y: u64): u64 {
        x * y
    }

    public fun add(x: u64, y: u64): u64 {
        x + y
    }

    public fun combined_operation(): u64 {
        // First, multiply 3 and 4
        let intermediate = apply(&Self::multiply, 3, 4);
        // Then, add 10 to the result
        apply(&|a: u64, b: u64| a + b, intermediate, 10)
    }
}

//# run 0xA11E::NestedFunctions::combined_operation

//# publish
module 0xA11E::ConditionalRunner {
    public fun two_args(x: u64, b: bool): u64 {
        if (b) {
            x
        } else {
            0
        }
    }

    public fun test_true(): u64 {
        two_args(100, true)
    }

    public fun test_false(): u64 {
        two_args(100, false)
    }
}

//# run 0xA11E::ConditionalRunner::test_true
//# run 0xA11E::ConditionalRunner::test_false