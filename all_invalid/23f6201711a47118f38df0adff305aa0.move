
//# publish
module 0xDEAD::TypeParameterTest {
    use std::vector;

    struct Container<T> has store, key {
        value: T
    }

    public fun create_container<T>(value: T): Container<T> {
        Container { value }
    }

    public fun get_container_value<T>(container: &Container<T>): &T {
        &container.value
    }

    public fun get_container_value_mut<T>(container: &mut Container<T>): &mut T {
        &mut container.value
    }

    public fun test_type_parameter<T>(val: T): T {
        let container = create_container<T>(val);
        let container_ref: &Container<T> = &container;
        let value_ref: &T = get_container_value(container_ref);
        // clone value for returning
        *value_ref
    }
}


//# run 0xDEAD::TypeParameterTest::test_type_parameter --args 42u64


//# publish
module 0xBADD::FunctionNamesAndSpecs {
    use std::vector;

    // Function name does not start with underscore and has explicit type parameter
    public fun process_data<X>(x: X): X {
        x
    }

    // Function with multiple type parameters and explicit return types
    public fun combine<T1, T2>(a: T1, b: T2): (T1, T2) {
        (a, b)
    }

    // Specification block for all functions in this module
    spec process_data<T> {
        // No specific properties for simplicity; placeholder for actual specs
    }

    spec combine<T1, T2> {
        // No conditions, just existence
    }

    // A function that calls other functions with various type parameters
    public fun runner() {
        let _ = process_data<u8>(5u8);
        let _ = combine<u16, bool>(100u16, true);
        // to ensure functions with different generics are checked
    }
}


//# run 0xBADD::FunctionNamesAndSpecs::runner


// Featurres:
// d7d672a1cc1c150fea48c574e56d50dd: Create specification blocks that target the entire module rather than individual members
// 1f390eda5af7e78edd4d96e25ae0e19f: Define functions with explicit type parameters (type parameter checks)
// 2da1f2b35c702c52170a944bcb8b662f: Define function names that do not start with an underscore ('_').
