
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // 1. Test variable assignment in both branches of an if-else with uninitialized variable.
    public fun test_if_assignments(flag: bool): u32 {
        let result: u32; // declare uninitialized
        if (flag) {
            result = 10;
        } else {
            result = 20;
        }
        result
    }

    // Helper: label to mark a specific point
    public fun label_point() {}

    // 2. Test the `elem_for_each_ref` logic with nested structs in vector
    // Define nested structs
    struct InnerStruct has store, key {
        value: u32,
    }

    struct OuterStruct has store, key {
        inner: InnerStruct,
        multiplier: u32,
    }

    // Function to apply a function across a vector of mutable references
    // Applies `func` to each `InnerStruct`'s `value` and accumulates sum multiplied by outer multiplier
    public fun elem_for_each_ref(vec: &mut vector<OuterStruct>, func: &mut (ref: &mut InnerStruct -> u32)): u32 {
        let total: u32 = 0;
        let len = vector::length(vec);
        let index = 0;
        while (index < len) {
            let item_ref: &mut OuterStruct = &mut vector::borrow_mut(vec, index);
            let inner_ref: &mut InnerStruct = &mut item_ref.inner;
            // Apply func to inner_ref
            let applied_value = func(&mut inner_ref);
            total = total + applied_value * item_ref.multiplier;
            index = index + 1;
        }
        total
    }

    // Function to increment inner.value by 1, used as a callback
    public fun increment_value(inner: &mut InnerStruct): u32 {
        inner.value = inner.value + 1;
        inner.value
    }

    // 3. Labels for jump points
    // For demonstration: a function that jumps to label1 or label2 based on a condition
    public fun control_flow(flag: bool): u64 {
        if (flag) {
            // label1 point
            label1:
            1u64
        } else {
            // label2 point
            label2:
            2u64
        }
    }
}


//# run 0xCAFE::TestModule::test_if_assignments --args true


//# run 0xCAFE::TestModule::test_if_assignments --args false


//# run 0xCAFE::TestModule::elem_for_each_ref --args 0


//# run 0xCAFE::TestModule::control_flow --args true


//# run 0xCAFE::TestModule::control_flow --args false

// Featurres:
// 23358b71c0ef160b4e84c7f263291e48: Test variable assignment in both branches of an if-else statement with an uninitialized variable.
// ef73e9e8f1da23750f1987aec8befa3b: Test that the `elem_for_each_ref` function correctly iterates over mutable fields within nested structs in a vector and accurately applies a provided function to accumulate a result.
// 33d2256708c8f2c0dc85490da48fef02: Define labels at specific points in code to mark positions for jumps and control flow management.
