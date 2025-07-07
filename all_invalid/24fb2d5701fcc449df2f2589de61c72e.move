
//# publish
module 0xDEAD::ClosureAndSumTest {
    use std::assert;
    use std::option;

    // Define a move-only, drop-only closure type with a stored u32 value
    struct MoveDropClosure has drop {
        internal_value: u32
    }

    // Define a copy, drop (copy + drop) closure type with a stored u32 value
    struct CopyDropClosure has copy, drop {
        internal_value: u32
    }

    // Function to invoke a move-drop closure with mutable borrow 
    public fun call_move_drop_closure(c: &mut MoveDropClosure): u32 {
        let result = c.internal_value + 10;
        // drop p, but it's a move-only closure, so no drop call needed
        result
    }

    // Function to invoke a copy-drop closure by copying it
    public fun call_copy_drop_closure(c: CopyDropClosure): u32 {
        let result = c.internal_value * 2;
        result
    }

    // Utility function to assign a move-drop closure and invoke it
    public fun test_move_drop_closure(value: u32): u32 {
        let c = MoveDropClosure { internal_value: value };
        // simulate a move by taking c as reference
        let c_ref = &mut c;
        call_move_drop_closure(&mut c_ref)
    }

    // Utility function to assign a copy-drop closure and invoke it
    public fun test_copy_drop_closure(value: u32): u32 {
        let c = CopyDropClosure { internal_value: value };
        call_copy_drop_closure(c)
    }

    // Function that sums all numbers less than `limit` which are multiples of 3 or 5
    public fun sum_multiples_3_or_5(limit: u64): u64 {
        let sum: u64 = 0;
        let i: u64 = 0;
        while (i < limit) {
            if (i % 3 == 0 || i % 5 == 0) {
                sum = sum + i;
            }
            i = i + 1;
        };
        sum
    }

    // A higher-order function accepting a closure to process the numbers
    public fun process_with_closure<F>(limit: u64, proc: F): u64
        where F: copy + drop + |u64| -> u64
    {
        let total: u64 = 0;
        let i: u64 = 0;
        while (i < limit) {
            total = total + proc(i);
            i = i + 1;
        };
        total
    }

    // Test closure movement and usage with sum of multiples
    public fun run_tests() {
        // Test move-only closure assignment and invocation
        let r1 = test_move_drop_closure(5);
        let r2 = test_move_drop_closure(15);
        // Test copy-drop closure
        let r3 = test_copy_drop_closure(7);
        // Test sum of multiples under 10
        let sum_under_10 = sum_multiples_3_or_5(10);
        assert!(sum_under_10 == 23, 1001);
        // Test sum of multiples under 1000
        let sum_under_1000 = sum_multiples_3_or_5(1000);
        assert!(sum_under_1000 == 233168, 1002);
        // Use process_with_closure with a move-only closure
        let move_closure = CopyDropClosure { internal_value: 2 };
        let total = process_with_closure(20, |x| (move_closure.internal_value) + x);
        assert!(total == 210, 1003);
        // Use process_with_closure with a copy closure
        let copy_closure = CopyDropClosure { internal_value: 3 };
        let total2 = process_with_closure(20, |x| (copy_closure).internal_value + x);
        assert!(total2 == 210, 1004);
    }
}


//# run 0xDEAD::ClosureAndSumTest::run_tests --signers 0xBADD


// Featurres:
// e13d4b239209aeab3adb2604d70b68e1: Check correctness of closures.
// bfb8322d0afd8398c17b545045bb38dc: Test that the `sum_multiples_3_or_5` function correctly computes the sum of all numbers less than the specified limit that are divisible by 3 or 5, including verifying results for limits of 10 and 1000.
// e01e5a9cc39cdaaa87c749c1ddc33640: Test that functions correctly assign and mutate move-only closures with drop and copy constraints within different scopes.
