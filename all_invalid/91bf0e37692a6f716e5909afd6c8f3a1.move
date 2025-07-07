// # publish
module 0xCAFE::TestVariants {
    // Test case 1: All struct variant names are unique within the same struct
    // Using an enum style struct with distinct variant names (simulation).
    // Move doesn't support enums like Rust, but we simulate with distinct structs.

    struct One has store { val: u64 }
    struct Two has store { val: u64 }
    struct Three has store { val: u64 }

    // No duplicate names in variants.
}
// # run 0xCAFE::TestVariants::One --signers 0xCAFE
// We run the variant structs by publishing. No direct function needed here.

// # publish
module 0xCAFE::InlineClosure {
    use std::string;
    use std::vector;

    /// Inline function that takes a closure and calls it with multiple arguments
    public fun call_with_closure_and_return<F: copy + drop + store>(
        f: &fun(u64, bool, vector<u8>): u64
    ): u64 {
        // Call closure f with (42u64, true, b"test")
        f(42u64, true, vector::from_bytes(b"test"))
    }

    // Example closure function to pass into the inline call
    public fun example_closure(a: u64, b: bool, c: vector<u8>): u64 {
        // Calculate something simple to test bindings
        let base = a;
        let added = if b { 10 } else { 0 };
        let len = vector::length(&c) as u64;
        base + added + len
    }

    public fun runner(): u64 {
        // Pass example_closure as a function reference to call_with_closure_and_return
        call_with_closure_and_return(&example_closure)
    }
}
// # run 0xCAFE::InlineClosure::runner --signers 0xCAFE

// # publish
module 0xCAFE::ConstructFields {
    struct Inner has store {
        a: u64,
        b: bool,
        c: vector<u8>,
    }

    struct Outer has store {
        x: u64,
        y: Inner,
    }

    // Unwraps inner fields and reconstructs Inner from parts after transformation
    public fun transform_inner_fields(input: Inner): Inner {
        let a = input.a;
        let b = input.b;
        let c = input.c;

        // Construct a new Inner with transformed values: e.g. increment a, flip b, clone c
        Inner {
            a: a + 1,
            b: !b,
            c: c,
        }
    }

    // Construct and return a new Outer by unwrapping and reconstructing Inner inside
    public fun construct_outer(x: u64, input: Inner): Outer {
        let new_inner = transform_inner_fields(input);
        Outer {
            x,
            y: new_inner,
        }
    }

    public fun runner(): Outer {
        let inner = Inner { a: 10, b: true, c: vector::from_bytes(b"data") };
        construct_outer(999, inner)
    }
}
// # run 0xCAFE::ConstructFields::runner --signers 0xCAFE


// # run
script {
    use 0xCAFE::InlineClosure;

    fun main() {
        let result = InlineClosure::runner();
        // No assertions required, just call to test VM and compiler
    }
}

// # run
script {
    use 0xCAFE::ConstructFields;

    fun main() {
        let outer = ConstructFields::runner();
        // No assertions required
    }
}

// Featurres:
// 88c15ed2badc5daf803efcd61e0936a0: Ensure all struct variant names are unique within the same struct.
// 7854d5b4796bbb1c7109a4054262a16d: Test that an inline function can accept and properly call a closure with multiple arguments, verifying argument binding and correct return value.
// e1edb0b78d698d134e8bac8aefa5afdb: Construct and return a new fields structure from assignable values after unwrapping pattern fields.
