//# publish
module 0xCAFE::TestDeprecatedGenerics {
    // Struct to test generic usage
    struct Container<T> {
        value: T,
    }

    // Inline function to compute double of a number, to test inlining optimization
    public inline fun double(x: u64): u64 {
        x + x
    }

    // Function to create a container with a value
    public fun create_container<T>(v: T): Container<T> {
        Container { value: v }
    }

    // Function to get the value from container, using deprecated generic syntax
    public fun get_value_with_deprecated<T>(c: &Container<T>): T {
        // Call the method with deprecated syntax
        // Note: the following line is the deprecated syntax for generics
        // i.e., method::<T>()
        c.value::<T>()
    }
}

//# run 0xCAFE::TestDeprecatedGenerics::create_container --signers 0xCAFE --args 42u64
//# run 0xCAFE::TestDeprecatedGenerics::get_value_with_deprecated --signers 0xCAFE --args 0xCAFE::TestDeprecatedGenerics::create_container::<u64>(42u64)

// Featurres:
// fefb18c0e965e13dcbcff3dd87b976bc: Use deprecated `::` generics syntax after the dot, with a warning in Move 2.2 or later, such as `obj.method::<T>()`.
// 7f06a6ddd1a6fd0080a3c81aa0d71531: Refer to standard modules (such as 'vector' and 'cmp') as implicit dependencies without needing direct imports.
// 4625b3aabf3f1e50655d70fe22b574f2: Use the inlining process to optimize code by replacing calls to inline functions with their bodies.
