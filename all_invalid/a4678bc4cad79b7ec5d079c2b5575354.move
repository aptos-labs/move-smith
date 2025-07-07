module 0x1::TestTransaction {

    use std::signer;

    // Struct with named fields (feature 1)
    struct MyStruct has copy, drop, store {
        foo: u64,
        bar: bool,
    }

    // Struct with tuple-like fields (feature 1)
    struct TupleStruct has copy, drop, store (u8, bool);

    // A function returning an option wrapping a bool, 
    // using optional generic type arguments (feature 3).
    public fun optional_generic<T: copy + drop>(val: T): Option<T> {
        Option::some<T>(val)
    }

    // A function to test return statements followed directly by unary or reference expressions without being parsed as binary operators (feature 2).
    public fun test_return_unary(): bool {
        // return immediately followed by unary minus
        return -true;  // unary minus applied to bool is invalid, so let's do it with an int instead.
    }

    public fun test_return_unary_int(): i64 {
        // return immediately followed by unary minus on int literal
        return -42;
    }

    public fun test_return_ref(): &u8 {
        let x = 10u8;
        return &x;
    }

    // Main test function to invoke the above functions and utilize the structs
    #[test]
    public fun transactional_test() {
        // Create instance of MyStruct with named fields
        let s = MyStruct { foo: 100, bar: true };

        // Create instance of TupleStruct with positional fields
        let t = TupleStruct(42, false);

        // Check optional generic function
        let opt = optional_generic<u64>(s.foo);
        assert!(Option::is_some(&opt), 0);

        // Test return followed by unary expressions
        let neg_val = test_return_unary_int();
        assert!(neg_val == -42, 1);

        // Test return followed by reference expression
        let r = test_return_ref();
        assert!(*r == 10, 2);
    }
}

module 0x1::Option {
    /// Minimal Option implementation for test
    struct Option<T> has copy, drop, store {
        value: bool,
        val: T,
    }

    public fun some<T>(val: T): Option<T> {
        Option { value: true, val }
    }

    public fun none<T>(): Option<T> {
        Option { value: false, val: move_from<T>() }
    }

    public fun is_some<T>(opt: &Option<T>): bool {
        opt.value
    }
    
    // Dummy function to satisfy none<T> to return a zero value for T, can be removed if T is copy and default
    fun move_from<T>(): T {
        abort 1  // For test only, or you can implement Default trait-like functionality if needed.
    }
}

// Featurres:
// f8a5f4d8aa8d95ae2f248e69416f2896: Name struct or tuple fields using identifiers as usual.
// 763a9a0b4cdb31d17703a38ffa5b9cb4: Test that `return` statements can be immediately followed by unary or reference expressions without being incorrectly parsed as binary operators.
// ec5d8bc5a8dddeab21d9a71e848f67d8: Use optional generic type arguments in your Move code by enclosing them within angle brackets '<' and '>' when specifying type parameters.
