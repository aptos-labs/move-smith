//# publish
module 0xabcde::higher_order_tests {
    // Function returning a closure that adds a captured offset to its input
    fun make_add_offset(offset: u64): |u64| has copy + drop {
        |x: u64| {
            x + offset
        }
    }

    // Function returning a closure with multiple captures
    fun make_mixed_closure(multiplier: u64, adder: u64): |u64, u64|(||u64) has copy + drop {
        return (|x, y| {
            // Inner closure captures both multiplier and adder
            || (x * multiplier + y + adder)
        })
    }

    // Function returning a nested higher-order function
    fun make_nested(): |u64|(|u64|(|u64|u64)) has copy + drop {
        return (|x: u64| {
            // Outer closure captures x
            |y: u64| {
                // Inner closure captures x and y
                |z: u64| {
                    x + y + z
                }
            }
        })
    }

    // Test function that validates the higher-order closures' behavior
    fun test() {
        // Test 1: add_offset closure
        let add_f = make_add_offset(5);
        assert!(add_f(10) == 15);
        assert!(add_f(0) == 5);

        // Test 2: mixed captures closure
        let mixed_f = make_mixed_closure(3, 7);
        let result = mixed_f(4, 6)();
        assert!(result == (4 * 3 + 6 + 7)); // 12 + 6 + 7 = 25

        // Test 3: nested higher-order closures
        let nested_f = make_nested();
        let inner_closure = nested_f(10); // captures x=10
        let inner_most_closure = inner_closure(20); // captures y=20
        let total = inner_most_closure(30); // z=30
        assert!(total == 10 + 20 + 30); // Should be 60
    }
}

//# run 0xabcde::higher_order_tests::test