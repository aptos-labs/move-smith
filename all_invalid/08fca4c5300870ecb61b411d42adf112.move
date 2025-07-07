
//# publish
module 0xCAFE::AdvancedGenerics {
    use std::vector;

    // Struct with multiple type parameters
    struct Pair<T1, T2> has copy, drop, store {
        first: T1,
        second: T2,
    }

    // Function with optional type parameters in specifications:
    // Here we just specify "T" and "U" but call the function without explicit type parameters to test inference.
    public fun make_pair<T, U>(x: T, y: U): Pair<T, U> {
        Pair<T, U> { first: x, second: y }
    }

    // Function returning a vector of Pair with concrete types u8 and bool
    public fun make_vector_of_pairs(): vector<Pair<u8, bool>> {
        vector[
            Pair<u8, bool> { first: 1u8, second: true },
            Pair<u8, bool> { first: 2u8, second: false }
        ]
    }

    // test(key="value", number=123)]
    public fun test_with_attributes(): u64 {
        // Just a dummy test function with attributes to check the parser accepts them
        42u64
    }
    
    // test(value=true)]
    public fun test_with_boolean_attribute(): u8 {
        7u8
    }
}


//# run 0xCAFE::AdvancedGenerics::make_pair --args 10u8 true


//# run 0xCAFE::AdvancedGenerics::make_vector_of_pairs


//# run 0xCAFE::AdvancedGenerics::test_with_attributes


//# run 0xCAFE::AdvancedGenerics::test_with_boolean_attribute


// Featurres:
// da67a855c6357f72934f12020e1bde4a: Specify multiple type parameters separated by commas within the angle brackets.
// 49b7a8368d3cf383a8162ffa3806d4f6: Annotate tests with #[test] attributes that can take key-value pairs with literal values for test configuration.
// 161e7adce5b7c3f41de21542ac64ac82: Define function signatures with optional type parameters in specifications.
