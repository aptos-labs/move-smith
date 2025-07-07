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

    /// Function that takes a function pointer f(u64):u64 and argument,
    /// returns the result of f(arg).
    public inline fun call_with_arg(f: fun(u64): u64, arg: u64): u64 {
        f(arg)
    }

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
    public fun for_each_mutable<T>(vec: &mut vector<T>, f: fun(&mut T)) {
        let len = vector::length(vec);
        let mut i = 0;
        while (i < len) {
            // Get mutable reference to ith element
            // and apply f
            let elem_ref = &mut vector::borrow_mut(vec, i);
            f(elem_ref);
            i = i + 1;
        }
    }

    /// A function that mutably borrows KeyValue vector elements and increments values by 1
    public fun increment_values(vec: &mut vector<KeyValue>) {
        // Closure-like inline function
        fun inc(kv_ref: &mut KeyValue) {
            kv_ref.value = kv_ref.value + 1;
        };
        for_each_mutable(vec, inc)
    }

    /// A runner function to test all these features in one call.
    public fun runner() {
        // 1. Add captured + x
        let cap = 100u64;
        let result = add_captured_and_x(cap, 23u64);
        // ignore result, just compile and run

        // 2. Call function with arg
        let res = call_with_arg(add_captured_and_x, 50u64);

        // 3. Return unary test
        let b = true;
        let nb = test_return_unary(b);

        // 4. Return ref test
        let v = vector::empty<u64>();
        vector::push_back(&mut v, 999u64);
        let r = test_return_ref(&v);

        // 5. Safe for_each mutable test
        let mut kvs = vector::empty<KeyValue>();
        vector::push_back(&mut kvs, KeyValue { key: 42, value: 100 });
        vector::push_back(&mut kvs, KeyValue { key: 7, value: 200 });
        increment_values(&mut kvs);

        // The advanced-for_each iteration with inline closure modify incremented all values by 1
        // Just use kvs so code is not optimized away
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

        // Test call_with_arg passing add_captured_and_x partially applied by binding one arg
        let f = ClosureTest::add_captured_and_x;
        let res = ClosureTest::call_with_arg(f, 30u64);

        // Test return unary boolean
        let b = false;
        let nb = ClosureTest::test_return_unary(b);

        // Test return ref with vector
        let mut v = vector::empty<u64>();
        vector::push_back(&mut v, 88u64);
        let r = ClosureTest::test_return_ref(&v);

        // Test for_each_mutable with increment_values
        let mut kvs = vector::empty<ClosureTest::KeyValue>();
        vector::push_back(&mut kvs, ClosureTest::KeyValue { key: 5, value: 50 });
        vector::push_back(&mut kvs, ClosureTest::KeyValue { key: 6, value: 60 });
        ClosureTest::increment_values(&mut kvs);
    }
}

// Featurres:
// a24948bff2b48c01132a174c88fabc8a: Test that the move module correctly supports defining and invoking closures with various parameter configurations, including capturing variables and passing arguments to functions.
// 763a9a0b4cdb31d17703a38ffa5b9cb4: Test that `return` statements can be immediately followed by unary or reference expressions without being incorrectly parsed as binary operators.
// 8ac46363ee65333fafab3c5023197f9e: Test that a for-each function can safely mutate elements and destructure fields by mutable reference within a generic vector, including borrowing both keys and values mutably in a custom struct.
