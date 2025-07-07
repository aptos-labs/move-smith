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

    // Optional: a runner function to test the call without args
    public fun run_create_and_get() {
        let c = create_container::<u64>(42);
        let v = get_value_with_deprecated(&c);
        // No assertions needed; just a test run
    }
}

//# run 0xCAFE::TestDeprecatedGenerics::run_create_and_get --signers 0xCAFE