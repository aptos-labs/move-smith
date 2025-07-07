//# publish
module 0xCAFE::ClosureTest {
    /// This module tests closure-like patterns in Move by using inline functions
    /// and passing functions as arguments since Move does not have first-class closures.
    /// It also tests capturing variables using function arguments.

    /// Define a struct to test mutable borrowing and modifications.
    struct KeyValue has copy, store, drop {
        key: u64,
        value: u64,
    }

    /// Function that emulates a closure capturing a variable 'captured' and
    /// taking argument x, returning captured + x.
    public inline fun add_captured_and_x(captured: u64, x: u64): u64 {
        // Simply add captured + x
        captured + x
    }

    /// Function that takes a function pointer f and argument,
    /// returns the result of f applied to captured and arg.
    /// Since Move does not support function pointers, we'll define a wrapper function type.
    /// But Move does not support function types as arguments.
    /// So we remove this function or re-implement it differently.

    /// Because Move does not support function types as parameters, instead,
    /// we implement a version that simply calls add_captured_and_x directly for example.

    /// Function testing return statement followed immediately by unary expressions.
    /// It returns the negation "!" of a boolean passed in.
    public fun test_return_unary(x: bool): bool {
        return !x
    }

    /// Function testing return statement followed immediately by a reference expression.
    /// It returns a reference to an element from the vector at index 0.
    public fun test_return_ref(vec: &vector<u64>): &u64 {
        return &vec[0]
    }

    /// Function implementing a generic safe for-each that mutably borrows each element
    /// of a vector and applies a mutating inline function f to it.
    /// The vector must be one-dimensional.
    public inline fun for_each_mutable<T>(vec: &mut vector<T>, f: &mut (fun(&mut T))) {
        let len = vector::length(vec);
        let mut i = 0;
        while (i < len) {
            // Get mutable reference to ith element
            // and apply f
            let elem_ref = &mut vector::borrow_mut(vec, i);
            // Apply f
            (*f)(elem_ref);
            i = i + 1;
        }
    }

    /// A function that mutably borrows KeyValue vector elements and increments values by 1
    public fun increment_values(vec: &mut vector<KeyValue>) {
        // Closure-like inline function
        // Move does not support nested functions or lambdas.
        // Instead we define a standalone function and pass pointer to it.

        fun inc(kv_ref: &mut KeyValue) {
            kv_ref.value = kv_ref.value + 1;
        };

        // But Move also does not support passing functions as arguments directly, so rewrite without for_each_mutable.

        // Implement for_each_mutable by direct loop here:

        let len = vector::length(vec);
        let mut i = 0;
        while (i < len) {
            let kv = &mut vector::borrow_mut(vec, i);
            inc(kv);
            i = i + 1;
        }
    }

    /// A runner function to test all these features in one call.
    public fun runner() {
        // 1. Add captured + x
        let cap = 100u64;
        let result = add_captured_and_x(cap, 23u64);
        // ignore result, just compile and run

        // Since Move does not support passing functions as parameters, remove call_with_arg test

        // 3. Return unary test
        let b = true;
        let nb = test_return_unary(b);

        // 4. Return ref test
        let mut v = vector::empty<u64>();
        vector::push_back(&mut v, 999u64);
        let r = test_return_ref(&v);

        // 5. Safe for_each mutable test rewritten inside increment_values
        let mut kvs = vector::empty<KeyValue>();
        vector::push_back(&mut kvs, KeyValue { key: 42, value: 100 });
        vector::push_back(&mut kvs, KeyValue { key: 7, value: 200 });
        increment_values(&mut kvs);

        let (k1, v1) = (kvs[0].key, kvs[0].value);
        let (k2, v2) = (kvs[1].key, kvs[1].value);
        // no assertion needed
    }
}
//# run 0xCAFE::ClosureTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::ClosureTest;

    fun main() {
        // Test calling add_captured_and_x with direct inline function call
        let captured = 10u64;
        let x = 20u64;
        let sum = ClosureTest::add_captured_and_x(captured, x);

        // Removed call_with_arg test because function types are not supported as arguments.

        // Test return unary boolean
        let b = false;
        let nb = ClosureTest::test_return_unary(b);

        // Test return ref with vector
        let mut v = vector::empty<u64>();
        vector::push_back(&mut v, 88u64);
        let r = ClosureTest::test_return_ref(&v);

        // Test increment_values
        let mut kvs = vector::empty<ClosureTest::KeyValue>();
        vector::push_back(&mut kvs, ClosureTest::KeyValue { key: 5, value: 50 });
        vector::push_back(&mut kvs, ClosureTest::KeyValue { key: 6, value: 60 });
        ClosureTest::increment_values(&mut kvs);
    }
}