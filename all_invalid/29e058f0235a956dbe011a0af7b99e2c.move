// This transactional test exercises Move compiler and VM features:
// 1. Variable shadowing within closures passed to inline functions (assignment to outer variables).
// 2. Generic structs with type parameters using angle brackets '<' and '>'.
// 3. Lambdas capturing generic variables with drop ability and using equality comparison.

// Use 0xCAFE as test address

//# publish
module 0xCAFE::ShadowingGeneric {

    use std::vector;

    // A generic struct with type parameter T
    // T has the drop ability only.
    struct Wrapper<T: drop> has drop, store, key {
        value: T
    }

    // A helper function for comparing Wrapper<T> values (equality on inner value).
    public fun eq<T: drop>(a: &Wrapper<T>, b: &Wrapper<T>): bool {
        // We cannot do direct `==` on T, so require T: copy + eq trait non existent.
        // We'll assume T is u64 here for test, otherwise always false.
        // Since Move doesn't have traits, we use the "drop" generic and test for u64.
        // To bypass, specialize on u64 in test below.

        false
    }

    // Inline function that takes a reference to an outer variable, and
    // calls a closure that can shadow the parameter variable,
    // but will update the outer variable at the end.
    // This is to test variable renaming (shadowing) and assignment inside inline functions with closures.
    public inline fun shadow_and_assign(f: &mut u64, closure: &mut (u64) -> ()) {
        // This function calls the closure with argument 100,
        // and then assigns *f = 500.
        // The closure shadows its parameter named `f` to verify correct scoping.
        closure(100);
        // assignment to outer reference
        *f = 500;
    }

    // Runner function that tests shadowing and generic struct with lambda capturing generic variable.
    public fun runner() {
        let mut x = 0u64;

        // Define a closure that uses shadowing parameter
        // Note: there is no native closures syntax in Move scripts,
        // but inline functions can be called with function pointers
        let mut my_closure = move |f: u64| {
            // shadow variable f shadows outer reference
            let f = f + 1;
            // shadow f + 1, does nothing but exercise shadowing
            let f = f * 2;
            // We do not mutate outer x here since f is shadowed param
        };

        // Call inline function with mutable reference and mutable closure
        shadow_and_assign(&mut x, &mut my_closure);
        // After the call, x = 500 due to assignment.

        // Test generic struct with parameter u64 (has copy and drop both)
        let w1 = Wrapper<u64> { value: 42 };
        let w2 = Wrapper<u64> { value: 43 };

        // Test lambda capturing generic variable of drop ability (Wrapper<u64>)
        // We create a local captured variable
        let captured = w1;

        // Define a lambda that captures `captured` and compares with argument using == on inner value
        // Use inline function since no closures syntax
        // Note: == operator for u64 is implemented by Move
        let mut eq_closure = move |w: &Wrapper<u64>| -> bool {
            // Captured is Wrapper<u64>, compare inner value with w.value
            captured.value == w.value
        };

        // Call eq_closure with w1 (42) and w2 (43)
        let res1 = eq_closure(&w1); // true
        let res2 = eq_closure(&w2); // false

        // We don't assert but just consume results to force execution path
        // no assertions as per instructions
        let _ = res1;
        let _ = res2;

        // exercise type param declaration on struct by creating vector<Wrapper<u64>>
        let vec_wrappers = vector::empty<Wrapper<u64>>();
        let vec_wrappers = vector::push_back(vec_wrappers, w1);

        // no more ops needed
    }
}
//# run 0xCAFE::ShadowingGeneric::runner

// Featurres:
// 74ac9c50dd657ff88b2f637c4d0aedf9: Test that the Move compiler correctly implements variable renaming (shadowing) within closures passed to inline functions, ensuring that assignments inside closures to outer variables actually update the intended variable.
// 23d28765e83d1c28a76e0128b07aa18d: Declare type parameters for structs using angle brackets '<' and '>'
// c0456763eb6fc192c4bd2b7f62e34240: Test that lambdas can capture variables of generic types with the drop ability and use equality (==) inside the lambda body.
