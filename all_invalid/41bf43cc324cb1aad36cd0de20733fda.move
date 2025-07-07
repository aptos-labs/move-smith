// # publish
module 0xCAFE::GenericContainer {
    use std::vector;

    /// A generic wrapper that contains a value of type T.
    struct Container<T> has copy, drop, store {
        value: T,
    }

    /// Generic struct with type parameter T
    struct Wrapper<T> has copy, drop, store {
        inner: Container<T>,
    }

    /// Creates a Container wrapping the provided value.
    public fun make_container<T>(val: T): Container<T> {
        Container { value: val }
    }

    /// Creates a Wrapper wrapping a Container wrapping the provided value.
    public fun make_wrapper<T>(val: T): Wrapper<T> {
        let c = make_container(val);
        Wrapper { inner: c }
    }

    /// Function that takes a tuple type argument and returns the first element.
    /// Demonstrates working with tuple types.
    public fun first_from_tuple(t: (u64, bool)): u64 {
        t.0
    }

    /// Function `two_args` as per requirement:
    /// Returns x if cond is true, else returns zero.
    public fun two_args(x: u64, cond: bool): u64 {
        if cond {
            x
        } else {
            0
        }
    }

    /// Runner function to test tuple extraction and generics
    public fun runner(): u64 {
        // Create a container of u64
        let c = make_container(42u64);
        // Create a wrapper of container<u64>
        let w = make_wrapper(c);

        // Test tuple first extraction
        let tup: (u64, bool) = (123u64, true);
        let first = first_from_tuple(tup);

        // Test two_args with true and false
        let two_true = two_args(10u64, true);
        let two_false = two_args(10u64, false);

        // Return sum to have some output
        first + two_true + two_false
    }
}
// # run 0xCAFE::GenericContainer::runner

// # run 0xCAFE::GenericContainer::two_args --args 55u64 true
// # run 0xCAFE::GenericContainer::two_args --args 55u64 false

// # run
script 0xCAFE::TestScript {
    use 0xCAFE::GenericContainer;

    fun main() {
        // Use generic container with vector<u8>
        let v = vector::empty<u8>();
        let c_vec = GenericContainer::make_container(v);

        // Use generic container with struct Wrapper<u64>
        let w = GenericContainer::make_wrapper(99u64);

        // Test tuple input
        let tup = (1u64, false);
        let first = GenericContainer::first_from_tuple(tup);

        // Call two_args with true and false, no signers needed for pure functions
        let val_true = GenericContainer::two_args(77u64, true);
        let val_false = GenericContainer::two_args(77u64, false);

        // No assertions needed, just call these functions to exercise compiler and VM
        let _ = c_vec;
        let _ = w;
        let _ = first;
        let _ = val_true;
        let _ = val_false;
    }
}

// Featurres:
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// 4cf2880fe87afa7d8e339827d2aa4ca1: Declare tuple types with anonymous fields in Move, using the syntax (Type1, Type2, ...), where fields are named '0', '1', etc.
// 6661ca4e9f4783e491ec7bfc079b1063: Test that the `two_args` function correctly returns the input value when the boolean argument is true and returns zero when it is false.
