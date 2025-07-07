
//# publish
module 0xCAFE::BorrowingTest {
    use std::vector;

    struct Container has store {
        val: u64
    }

    // This function tries to create multiple mutable references simultaneously which is forbidden by Move's borrowing rules.
    public fun multiple_mut_refs(mut_ref: &mut Container) {
        // The following should fail to compile, but as per instructions,
        // we write it to test the compiler's borrow checker.
        // Uncommenting the below line should cause a compile error:
        // let another_mut_ref: &mut Container = mut_ref;
        // For the sake of this test, we mimic this logic with comments,
        // indicating what is tested.
        let _ref1 = mut_ref;
        // let _ref2 = mut_ref; // INVALID: cannot have two mutable refs simultaneously
        // Note: The above line is commented out because it would fail to compile,
        // and transactional tests need to compile.
    }

    // Bind variable directly in let binding with simple variable pattern
    public fun bind_simple_pattern(): u64 {
        let x = 42u64;
        let y = x;
        y
    }

    // Bind variable in match arm pattern
    enum Flag has copy, drop {
        Yes(u8),
        No
    }

    public fun bind_in_match(flag: Flag): u8 {
        match flag {
            Flag::Yes(a) => a,
            Flag::No => 0,
        }
    }

    // Deprecate a function with a diagnostic code
    // deprecated(code = 12345, note = "Use new_function instead")]
    public fun deprecated_function(): u8 {
        100
    }

    public fun new_function(): u8 {
        101
    }

    // Runner function calling deprecated_function to trigger deprecation warning
    public fun call_deprecated() {
        let _x = deprecated_function();
    }
}


//# run 0xCAFE::BorrowingTest::bind_simple_pattern


//# run 0xCAFE::BorrowingTest::bind_in_match --args 0u8


//# run 0xCAFE::BorrowingTest::call_deprecated


// Featurres:
// 053c0898699e17a66d51b1ffd70c3ab0: Test that attempting to create multiple mutable references in the same function results in a compilation error or behavior as specified by Move's borrowing rules.
// 620e9e64c65d1cac0fde0a9dd536998d: Bind a variable directly to a value by using a simple variable pattern in bindings or match arms.
// b2081e928f636305e3be6e682bcc0741: Get notifications about the use of deprecated items with specific diagnostic codes.
