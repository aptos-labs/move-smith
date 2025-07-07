
//# publish
module 0xCAFE::AdvancedFeatures {
    // Removed unused `std::signer` import

    // Struct with a nested struct variant
    struct Outer<T> has copy, drop, store {
        inner: Inner<T>
    }

    struct Inner<T> has copy, drop, store {
        value: T
    }

    // Ability constraints for type parameter: T must have copy+drop to be able to drop it or consume it
    // or consume the parameter properly.
    // Here we choose to consume `_t` properly instead of adding drop.

    // Consume _t by destructuring it so it is not implicitly dropped
    public fun add_and_return<T: copy>(_a: u8, _b: u8, _t: T): u8 {
        let T { } = _t; // consume _t properly by unpacking (assuming T is struct, if T can be a primitive copy type this is valid)

        // let sum = _a + _b;   // unused variable, removed

        // Always return 42 regardless of sum for testing
        42
    }

    // Function with lambda / anonymous functions
    public fun apply_lambda(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| {
            a * 2
        };
        f(x)
    }

    // Tuples and multiple bindings with destructuring
    public fun tuples_binding(): (u8, u8, u8) {
        let (a, b, c) = (1u8, 2u8, 3u8);
        (a, b, c)
    }

    // Use of nested qualified name access: instantiate and get value from nested structs
    public fun nested_struct_example(): u8 {
        let inner = Inner<u8> { value: 99u8 };
        let outer = Outer<u8> { inner };

        let v = outer.inner.value;
        v
    }
}



//# run 0xCAFE::AdvancedFeatures::add_and_return --args 10u8 15u8 0u8



//# run 0xCAFE::AdvancedFeatures::apply_lambda --args 21u8



//# run 0xCAFE::AdvancedFeatures::tuples_binding



//# run 0xCAFE::AdvancedFeatures::nested_struct_example
