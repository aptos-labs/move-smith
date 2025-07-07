
//# publish
module 0xCAFE::GenericStructAssignment {
    use std::vector;

    /// A simple generic struct for testing instantiation and assignment
    struct Container<T> has copy, drop, store {
        value: T
    }

    /// A nested generic struct
    struct NestedContainer<T> has copy, drop, store {
        inner: Container<T>
    }

    /// A struct using a byte string field to test ASCII-only literals
    struct ByteStringHolder has copy, drop, store {
        data: vector<u8>
    }

    /// Instantiate Container<u8> and assign field value, then reassign it
    public fun test_u8_assignment() {
        let c = Container<u8> { value: 10u8 };
        c.value = 42u8;
    }

    /// Instantiate Container<u64> and assign field value, then reassign it
    public fun test_u64_assignment() {
        let c = Container<u64> { value: 1u64 };
        c.value = 9999u64;
    }

    /// Instantiate NestedContainer<u8> then assign inner Container's value field
    public fun test_nested_assignment() {
        let n = NestedContainer<u8> { inner: Container<u8> { value: 0u8 } };
        n.inner.value = 255u8;
    }

    /// Instantiate ByteStringHolder with ASCII-only byte string and assign a new ASCII byte string
    public fun test_byte_string_assignment() {
        let b = ByteStringHolder { data: b"HelloASCII" };
        b.data = b"WorldText";
    }

    /// Instantiate Container with a vector as type param and assign
    public fun test_container_with_vector() {
        let c = Container<vector<u8>> { value: b"ABCDE" };
        c.value = b"FGHIJ";
    }

    /// A "runner" function that calls all above testers in one transaction
    public fun runner() {
        test_u8_assignment();
        test_u64_assignment();
        test_nested_assignment();
        test_byte_string_assignment();
        test_container_with_vector();
    }
}


//# run 0xCAFE::GenericStructAssignment::runner


//# publish
module 0xCAFE::NegativeTests {
    use std::vector;

    struct Dummy has copy, drop, store {
        x: u8
    }

    /// Attempt to instantiate a struct with non-generic syntax, expect compiler error (negative test)
    /// (This is commented because transactional tests must compile. Use comments to show negative test plan.)
    /*
    public fun bad_instantiation() {
        let d = Dummy(10u8); // This should fail: no tuple-like instantiation syntax in Move
    }
    */

    /// Attempt to assign non-ASCII bytes in byte string literal - expect compile error (negative test)
    /*
    public fun non_ascii_bytes() {
        let b = b"\xFF\xFE"; // Invalid bytes outside ASCII range - expect error
    }
    */

    /// Attempt assigning to a literal, which is invalid
    /*
    public fun invalid_assignment() {
        5u8 = 10u8; // invalid left value
    }
    */
}

// Note: Negative tests are documented in comments since transactional tests must compile.


// Featurres:
// a2d34cd27e5cc336633977d53e550c66: Instantiate generic structs with specific type parameters using the 'StructInstantiation<types>' syntax.
// c2690b9c0a9fa1771bbd371be5f3e8e0: Create assignment expressions with left-value and right-value.
// 44c581ac2d6f93070719f88426073f6d: Use ASCII characters only in byte strings.
