//# publish
module 0xCAFE::TypeArgAndLintTest {
    use std::vector;

    #[lint(skip = "unused_var, missing_docs")]
    struct LintedStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    public inline fun inline_add(a: &u8, b: &u8): u8 {
        *a + *b
    }

    // Test function using a space before `<` in type argument disambiguation: `vector < LintedStruct >`
    public fun test_type_arg_space() {
        let mut v = vector < LintedStruct > [];
        vector::push_back(&mut v, LintedStruct {a: 1, b: 2});
        vector::push_back(&mut v, LintedStruct {a: 3, b: 4});
        let item_ref: &LintedStruct = vector::borrow(&v, 0);
        let sum = inline_add(&item_ref.a, &item_ref.b);
        // no assertion needed
    }

    public fun runner() {
        test_type_arg_space();
    }
}

//# run 0xCAFE::TypeArgAndLintTest::runner


//# publish
module 0xCAFE::MultiMutRefTest {
    use std::vector;

    struct Container has store {
        vals: vector<u64>,
    }

    public fun create_container(): Container {
        let vals = vector::empty<u64>();
        vector::push_back(&mut vals, 10);
        vector::push_back(&mut vals, 20);
        vector::push_back(&mut vals, 30);
        Container {vals}
    }

    // Inline function that takes multiple mutable references to elements of a vector inside Container.
    // This tests multi-mutability and scoping inside closure.
    public inline fun update_pairs(container: &mut Container) {
        let len = vector::length(&container.vals);
        let mut i = 0;
        while (i + 1 < len) {
            // Borrow two mutable refs from different elements separately - allowed as separate borrows
            let elem1: &mut u64 = vector::borrow_mut(&mut container.vals, i);
            let elem2: &mut u64 = vector::borrow_mut(&mut container.vals, i + 1);

            // Update both elements inside a block to test inline function scoping
            {
                *elem1 = *elem1 + 1;
                *elem2 = *elem2 + 2;
            };

            i = i + 2;
        };
    }

    // Function to test combination of shared and mutable borrows in a loop with closure that shadows variables and uses scoping
    public fun shared_and_mut_loop(container: &mut Container) {
        let len = vector::length(&container.vals);
        let mut sum: u64 = 0;
        let mut i = 0;
        while (i < len) {
            let shared_ref: &u64 = vector::borrow(&container.vals, i);
            sum = sum + *shared_ref;

            {
                // Inside this block, create mutable borrow to the element and shadow `shared_ref`
                let shared_ref: &mut u64 = vector::borrow_mut(&mut container.vals, i);
                *shared_ref = *shared_ref + 5;
            };
            i = i + 1;
        };
    }

    public fun runner() {
        let mut c = create_container();
        update_pairs(&mut c);
        shared_and_mut_loop(&mut c);
    }
}

//# run 0xCAFE::MultiMutRefTest::runner

// Featurres:
// 75fff8fc3ba40c50396bcf7caeae5564: Write type arguments with a space before the '<' when necessary to disambiguate the '<' operator from a generic type parameter.
// aaa620358010856cd032313ad4729102: Use the #[lint(skip = ...)] attribute to specify Move lint checks to skip for a particular code item.
// ab1f58cc1de6658a7f70d92c549e66f8: Test that an inline function can safely take multiple mutable references to fields of a struct within a mutable vector, allowing both shared and mutable borrowing in a loop (multi-mutability), and that scoping works correctly inside the closure.
