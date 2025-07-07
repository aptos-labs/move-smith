
//# publish
module 0xCAFE::PragmaTest {
    // Example of pragma with comma-separated key-value pairs
    // pragma(owner = "0xCAFE", priority = "high", version = 1)]
    struct Dummy has copy, drop {}

    // A function just to confirm pragma usage compiles
    public fun dummy() {}
}


//# publish
module 0xCAFE::ClosureCapture {
    use std::vector;

    // Function that takes a closure |u8|u8 that captures and mutates a variable from the outer scope
    // The captured variable is `counter` which is mutable and is incremented each call
    public fun run_capture() {
        let counter = 0u8;

        let incrementer: |u8| u8 = |x: u8| {
            counter = counter + 1;
            counter + x
        };

        // Call incrementer multiple times to mutate captured 'counter'
        let r1 = incrementer(5u8);
        let r2 = incrementer(10u8);

        // Dummy usage of results to avoid unused var warnings
        let _ = r1 + r2 + counter;
    }

    // Inline function that takes a closure and calls it twice, returning a tuple
    public inline fun twice_call(f: |u8| u8, val: u8): (u8, u8) {
        (f(val), f(val))
    }

    public fun test_twice_call() {
        let state = 0u8;
        let closure = |v: u8| {
            state = state + v;
            state
        };

        let (a, b) = twice_call(closure, 3u8);
        let _ = a + b + state;
    }
}


//# publish
module 0xCAFE::BuiltinFunctionsTest {
    use std::signer;
    use std::vector;
    use std::string;
    use std::option;

    // Calling all built-in Move functions provided by the compiler here:

    public fun test_all_builtins(s: signer) {
        // Vector builtins
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 42u8);
        let len = vector::length(&v);
        let b = *vector::borrow(&v, 0);

        let v2 = vector::empty<u8>();
        vector::swap(&mut v, &mut v2);
        let is_empty = vector::is_empty(&v2);
        let popped = vector::pop_back(&mut v2);

        // Signer builtins
        let addr = signer::address_of(&s);

        // String related builtins
        let byte_str: vector<u8> = b"builtin";
        let utf8_str = string::utf8(&byte_str);

        // Option builtins
        let some_val = option::some<u64>(100);
        let none_val = option::none<u64>();

        let is_some = option::is_some(&some_val);
        let is_none = option::is_none(&none_val);

        let _ = (len, b, is_empty, popped, addr, is_some, is_none, utf8_str);
    }
}


//# run 0xCAFE::PragmaTest::dummy


//# run 0xCAFE::ClosureCapture::run_capture


//# run 0xCAFE::ClosureCapture::test_twice_call


//# run 0xCAFE::BuiltinFunctionsTest::test_all_builtins --signers 0xBEEF


// Featurres:
// 5e8718f398ecaa6b846b41df1b08ebe6: Define pragma properties with comma-separated key-value pairs within the '#[pragma]' annotation.
// b7338995bef53aa6347c3d6dbb5eb91c: Test that closures can capture and mutate variables from their enclosing scope when passed as inline function parameters.
// f38b160b196d610bbefb97265eba037b: Use the set of all built-in function names provided by the compiler.
