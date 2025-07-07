//# publish
module 0xCAFE::ReferenceSafetyTest {
    // Function to demonstrate defining functions within a module
    public fun create_vector(): vector<u8> {
        let v = b"Hello".to_vec();
        v
    }

    // Function to test reference safety analysis (simulate by assigning references)
    public fun borrow_and_return(v: &vector<u8>): &vector<u8> {
        // Borrowing reference to v; in actual bytecode, reference safety will be analyzed
        v
    }

    // Runner function to test referencing
    public fun run_reference_safety_test() {
        let vec = create_vector();

        // Borrow a reference from `vec`
        let v_ref = borrow_and_return(&vec);
        // v_ref is a reference borrowed from vec, safe here.
    }
}
//# run 0xCAFE::ReferenceSafetyTest::run_reference_safety_test

//# publish
module 0xCAFE::DestructuringBindingTest {
    // Destructuring tuple in function parameter
    public fun process_tuple(input: (u64, bool)): u64 {
        // Access the tuple elements via pattern matching
        let (number, flag) = input;
        if (flag) {
            number
        } else {
            0
        }
    }

    // Struct definition for destructuring
    struct Point {
        x: u64,
        y: u64,
    }

    // Function to destructure struct
    public fun process_point(point: Point): u64 {
        let Point { x, y } = point;
        x + y
    }

    // Runner function to exercise destructuring
    public fun run_destructuring() {
        let tuple_data = (42, true);
        let result1 = process_tuple(tuple_data);

        let p = Point { x: 10, y: 20 };
        let result2 = process_point(p);
    }
}
//# run 0xCAFE::DestructuringBindingTest::run_destructuring