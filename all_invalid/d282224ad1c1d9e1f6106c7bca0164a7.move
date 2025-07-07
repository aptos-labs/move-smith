
//# publish
module 0xCAFE::ComplexFeatures {
    use std::option;

    struct ComplexStruct<T, U> has store {
        a: u64,
        b: T,
        c: option::Option<U>,
    }

    /// Mutate a ComplexStruct by incrementing `a` and replacing `b` and optional `c`.
    /// Performs mutations in multiple inline code blocks.
    public fun mutate_complex<T, U>(cs_ref: &mut ComplexStruct<T, U>, new_b: T, new_c: option::Option<U>) {
        // First inline block: mutate field a
        {
            cs_ref.a = cs_ref.a + 1;
        };

        // Second inline block: mutate field b
        {
            cs_ref.b = new_b;
        };

        // Third inline block: mutate field c
        {
            cs_ref.c = new_c;
        };
    }

    /// Inline function to increment the u64 field a by delta.
    public inline fun increment_a<T, U>(cs_ref: &mut ComplexStruct<T, U>, delta: u64) {
        cs_ref.a = cs_ref.a + delta;
    }

    /// Creates a ComplexStruct with provided a, b, and c values.
    public fun create_complex<T, U>(a: u64, b: T, c: option::Option<U>): ComplexStruct<T, U> {
        ComplexStruct { a, b, c }
    }

    /// Creates a ComplexStruct with optional type parameter omitted.
    public fun create_complex_no_option<T>(a: u64, b: T): ComplexStruct<T, bool> {
        ComplexStruct { a, b, c: option::none<bool>() }
    }

    /// Function that uses positional unpacking on a ComplexStruct with optional type parameter.
    /// Unpacks fields inside parameter destructuring.
    public fun positional_unpack_and_return_sum<T: copy, U>(cs: ComplexStruct<T, U>): u128 {
        let ComplexStruct { a: aa, b: _bb, c: _cc } = cs;
        (aa as u128) + 1u128 // return a + 1 (as u128 to test wider type)
    }

    /// Function with nested positional unpacking in a let-binding,
    /// extracts fields and returns a tuple with a and c (if present).
    public fun nested_positional_unpack<T: copy, U: copy>(cs: ComplexStruct<T, U>): (u64, option::Option<U>) {
        let ComplexStruct { a, b: _b, c: c_opt } = cs;
        (a, c_opt)
    }

    /// Runner that creates a ComplexStruct with optional param, mutates it via inline blocks,
    /// then uses nested unpacking to return the current state.
    public fun runner_mutations() : (u64, u64, option::Option<bool>) {
        let cs = ComplexStruct { a: 10u64, b: 20u64, c: option::some<bool>(true) };

        // Inline code block mutating complex struct fields using references.
        {
            increment_a(&mut cs, 5u64);
        };

        // Another inline code block performing mutation again
        {
            mutate_complex(&mut cs, 30u64, option::some<bool>(false));
        };

        // Positional unpacking nested in a let-binding.
        let (a_val, c_opt) = nested_positional_unpack(cs);
        (a_val, cs.b, c_opt)
    }

    /// Runner that tests optional type param usage: create with and without Option param and unpack fields.
    public fun runner_optional_type_param() : (u64, u64, bool, u64, u64) {
        let cs_with_option = create_complex<u64, bool>(1u64, 100u64, option::some<bool>(true));
        let cs_without_option = create_complex_no_option<u64>(2u64, 200u64);

        let ComplexStruct { a: a1, b: b1, c: c1 } = cs_with_option;
        let ComplexStruct { a: a2, b: b2, c: c2 } = cs_without_option;

        // Extract option value or default to false
        let val_c1 = option::borrow(&c1)
            .map(|v| *v)
            .unwrap_or(false);
        let val_c2 = option::borrow(&c2)
            .map(|v| *v)
            .unwrap_or(false);

        // Sum up to produce a signature tuple showing all extracted values
        (a1, b1, val_c1, a2, b2)
    }

    /// Runner testing positional unpacking as function argument with nested pattern.
    public fun runner_positional_unpack_arg() : (u64, option::Option<bool>) {
        let cs = create_complex<u64, bool>(42u64, 7u64, option::some<bool>(true));
        unpack_and_return(cs)
    }

    /// Takes positional struct with nested unpacking in parameter pattern,
    /// returns tuple of a and c.
    public fun unpack_and_return<T, U>(ComplexStruct { a, b: _b, c }: ComplexStruct<T, U>): (u64, option::Option<U>) {
        (a, c)
    }
}


//# run 0xCAFE::ComplexFeatures::runner_mutations


//# run 0xCAFE::ComplexFeatures::runner_optional_type_param


//# run 0xCAFE::ComplexFeatures::runner_positional_unpack_arg


// Featurres:
// 769a92c92b8a1e2b692445101ad8ac4e: Test that both regular and inline functions can correctly mutate a struct reference across multiple inline code blocks in a single function.
// e7942191158e0962c7cd28357561f31e: Define and use optional (nullable) type argument lists for functions, structs, or generics
// cf19229be3631410204ac4e1fb39f4b0: Handle positional unpacking of field lists, including nested unpacking expressions.
