//# publish
module 0xBADD::TypeArgAndSpecTest {
    use std::vector; // Added to use vector

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
        vector::empty::<T>() // Corrected syntax: explicit generic arguments with ::<T>
    }

    // Spec fun to specify properties of create_vector_of_type
    spec fun spec_create_vector_of_type<T>(): bool {
        // the vector is empty after creation
        exists { 
        }
    }

    // Function demonstrating expression with type argument
    public fun test_type_expr<T>(value: T): vector<T> {
        create_vector_of_type::<T>() // Use explicit generic syntax
    }

    // Spec for test_type_expr
    spec fun spec_test_type_expr<T>(value: T): bool {
        // We can specify that the resulting vector is empty
        exists { 
        }
    }
}
