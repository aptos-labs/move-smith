
//# publish
module 0xBADD::TypeArgAndSpecTest {
    use std::string;

    // Struct with type parameter as phantom to avoid warnings
    struct PhantomStruct<T> has store, drop, key {
        _marker: core::marker::PhantomData<T>,
    }

    // Function using type argument, to be used in test
    public fun process_with_type<T>(value: T): T {
        value
    }

    // Spec fun with full signature, testing type parameters
    spec fun spec_process_with_type<T>(v: T): bool {
        exists { // dummy clause to suppress warnings
        }
    }

    // Function returning vector of type parameter, testing expression with type args
    public fun create_vector_of_type<T>(): vector<T> {
        vector::empty<T>()
    }

    // Spec fun to specify properties of create_vector_of_type
    spec fun spec_create_vector_of_type<T>(): bool {
        // the vector is empty after creation
        exists { 
        }
    }

    // Function demonstrating expression with type argument
    public fun test_type_expr<T>(value: T): vector<T> {
        create_vector_of_type<T>()
    }

    // Spec for test_type_expr
    spec fun spec_test_type_expr<T>(value: T): bool {
        // We can specify that the resulting vector is empty
        exists { 
        }
    }
}


//# run 0xBADD::TypeArgAndSpecTest::process_with_type --args 42u64

//# run 0xBADD::TypeArgAndSpecTest::create_vector_of_type --args

//# run 0xBADD::TypeArgAndSpecTest::test_type_expr --args 123u8


// Featurres:
// 05aa80fd5e63f458b64601adc3835eac: Test expressions with type arguments.
// 9603912541cbfa8a6e2cb5d75712a7ac: Define specification functions using spec fun with full Move-like function signatures in spec blocks.
// 7b723975ddaef54a437e966dc929fcd2: Declare type parameters in Move structs as phantom to avoid warnings for unused parameters.
