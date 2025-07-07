//# publish
module 0xc0ffee::nested_match_test {
    // Define nested enums with variants including named fields, wildcards, and guards
    enum Outer has drop {
        Variant1 { inner: Inner, flag: bool },
        Variant2 { inner: Inner, value: u64 },
        Variant3,
    }

    enum Inner has drop {
        A { x: u8, y: u8 },
        B { x: u16 },
        C,
    }

    // Helper function to test destructuring with nested pattern matching
    public fun match_nested_enum(o: Outer) {
        match (o) {
            Outer::Variant1 { inner: Inner::A { x: 1, y: y_val }, flag: true } => {
                // Match when inner is A with specific x, y, and flag true
            },
            Outer::Variant1 { inner: Inner::A { x: _, y: _ }, flag: false } => {
                // Match when inner is A with any x, y, and flag false
            },
            Outer::Variant1 { inner: Inner::B { x: x_val }, .. } => {
                // Match when inner is B with a specific x, ignore flag
            },
            Outer::Variant2 { inner: Inner::C, value: v } if v > 100 => {
                // Match Variant2 with inner C and value greater than 100
            },
            Outer::Variant2 { .. } => {
                // Catch-all for Variant2 with other values
            },
            _ => {
                // Wildcard catch-all for all other cases
            }
        }
    }

    // Function to test unreachable code detection with complex guards
    public fun test_unreachable_cases(o: Outer) {
        match (o) {
            Outer::Variant3 => {
                // No bound variables, always matches Variant3
            },
            Outer::Variant1 { inner: Inner::A { x: xx, y: yy }, flag: ff } if xx == 255 && ff => {
                // Specific pattern, but the guard might be unreachable if xx != 255
            },
            Outer::Variant1 { inner: Inner::A { x: xx, y: yy }, flag: ff } if xx != 255 => {
                // Could be unreachable if previous guard always captures previous case
            },
            _ => {}
        }
    }

    // Additional test covering nested destructuring with wildcards and guards
    public fun complex_match(o: Outer, val: u8, condition: bool) {
        match (o) {
            Outer::Variant2 { inner: Inner::B { x: x_val }, value: v } if v == val && condition => {
                // Matches when inner is B with x matching, value equals val, and condition true
            },
            Outer::Variant2 { inner: Inner::B { x: _ }, .. } => {
                // Match other B variants
            },
            Outer::Variant1 { inner: Inner::C, .. } => {
                // Match when inner is C
            },
            _ => {}
        }
    }
}

//# run
// Call the new functions with various inputs to exercise pattern matching

// Example calls (would be part of test harness or inline tests)
public fun run_tests() {
    // Instantiate various nested enums
    let a1 = Outer::Variant1 { inner: Inner::A { x: 1, y: 2 }, flag: true };
    let a2 = Outer::Variant1 { inner: Inner::A { x: 42, y: 99 }, flag: false };
    let b1 = Outer::Variant1 { inner: Inner::B { x: 12345 }, flag: true }; // invalid, for testing purpose
    let c1 = Outer::Variant2 { inner: Inner::C, value: 150 };
    let c2 = Outer::Variant2 { inner: Inner::A { x: 10, y: 20 }, value: 50 };
    let d = Outer::Variant3;
    let e = Outer::Variant2 { inner: Inner::B { x: 77 }, value: 42 };

    // Call matching functions with these examples
    match_nested_enum(a1);
    match_nested_enum(a2);
    match_nested_enum(c1);
    match_nested_enum(c2);
    match_nested_enum(d);
    match_nested_enum(e);

    // Guards examples
    test_unreachable_cases(a1);
    test_unreachable_cases(d);
    test_unreachable_cases(c2);

    // Complex nested destructuring
    complex_match(c2, 50, true);
    complex_match(e, 42, false);
    complex_match(Outer::Variant2 { inner: Inner::B { x: 77 }, value: 42 }, 42, true);
}