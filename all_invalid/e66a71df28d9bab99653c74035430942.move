module 0x1::TestCommaSeparatedLists {

    use std::signer;

    // 1 & 2: Define a struct with comma-separated fields enclosed in braces.
    // 3: Add a type constraint to the struct's type parameter (copyable).
    //
    // Here, T must implement the copy trait.
    struct Container<T: copy> {
        value1: u64,
        value2: T,
        flag: bool,
    }

    // Function with multiple parameters in comma-separated list enclosed in parentheses,
    // including generic constrained parameter U: copy
    public fun create_container<T: copy, U: copy>(
        a: u64,
        b: T,
        c: bool,
        d: U
    ): Container<T> {
        let container = Container<T> {
            value1: a,
            value2: b,
            flag: c,
        };

        // Use d in some trivial way to ensure argument parsing works fine
        let _dummy: U = d;

        container
    }

    // Function accepts comma-separated list of arguments.
    public fun update_flag<T: copy>(container: &mut Container<T>, new_flag: bool) {
        container.flag = new_flag;
    }

    #[test_only]
    public fun test() {
        // Create a Container<u64>
        let c1 = create_container<u64, bool>(10, 42, false, true);

        // Verify fields
        assert!(c1.value1 == 10, 1);
        assert!(c1.value2 == 42, 2);
        assert!(c1.flag == false, 3);

        // Mutable Container to test update flag
        let mut c2 = create_container<u8, u64>(5, 7, true, 100);

        // Update the flag field
        update_flag(&mut c2, false);

        assert!(c2.flag == false, 4);

        // Test comma-separated argument lists in assert! macro
        assert!(c2.value1 == 5, 5);

        // Test that the compiler enforces type constraints by trying an invalid call (commented since it won't compile)
        // let invalid = create_container<vector<u8>, bool>(0, vector[1,2], true, false);
        // This would fail since vector<u8> is not copyable.
    }
}

// Featurres:
// 9131b37f58fd482dcc6bfc9a83ea2737: Define comma-separated lists of items (such as function parameters, struct fields, or arguments) enclosed in delimiters (e.g., parentheses or braces).
// 2db8483833080785fd845c41e4ac7367: Write comma-separated lists of elements in Move code, such as parameter lists, struct fields, or similar constructs
// 46c9b97e99d80c136ca51c5f26d07474: Add type constraints to struct type parameters
