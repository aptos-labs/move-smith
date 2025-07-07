//# publish
module 0xc0ffee::test_struct_pattern {
    struct Data {
        a: u32,
        b: bool,
    }

    // Function that swaps values using pattern matching with field renaming
    fun swap_fields(x: u32, y: bool): (u32, bool) {
        let Data { a: new_a, b: new_b } = Data { a: y as u32, b: x != 0 };
        (new_a, new_b)
    }

    // Function that initializes a struct and rebinds with different field names, returning swapped values
    fun rebind_and_swap(): (u32, bool) {
        let val_a = 100;
        let val_b = true;
        let Data { a: other_a, b: other_b } = Data { a: val_b as u32, b: val_a != 0 };
        (other_a, other_b)
    }

    // Function that swaps data passed in struct fields directly
    fun swap_struct_fields(d1: Data, d2: Data): (u32, bool, u32, bool) {
        let Data { a: a1, b: b1 } = d1;
        let Data { a: a2, b: b2 } = d2;
        (a2, b2, a1, b1)
    }

    // Function that constructs and matches a nested pattern with renaming
    fun nested_pattern_match(data: Data): (u32, bool) {
        // For demonstration, we reuse a simple pattern; real nested patterns would be more complex
        let Data { a: renamed_a, b: renamed_b } = data;
        (renamed_a, renamed_b)
    }

    // Test functions
    fun test_swap_fields(): (u32, bool) {
        swap_fields(42, false)
    }

    fun test_rebind_and_swap(): (u32, bool) {
        rebind_and_swap()
    }

    fun test_swap_struct_fields(): (u32, bool, u32, bool) {
        swap_struct_fields(
            Data { a: 7, b: true },
            Data { a: 99, b: false }
        )
    }

    fun test_nested_pattern(): (u32, bool) {
        let d = Data { a: 123, b: false };
        nested_pattern_match(d)
    }
}

//# run 0xc0ffee::test_struct_pattern::test_swap_fields
//# run 0xc0ffee::test_struct_pattern::test_rebind_and_swap
//# run 0xc0ffee::test_struct_pattern::test_swap_struct_fields
//# run 0xc0ffee::test_struct_pattern::test_nested_pattern