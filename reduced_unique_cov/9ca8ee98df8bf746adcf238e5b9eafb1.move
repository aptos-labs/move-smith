
//# publish
module 0xCAFE::TestFeatures {
    use std::signer;

    // 1: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
    public fun add_two_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    // 2: Write functions containing lambda (anonymous function) expressions.
    public fun lambda_usage(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        adder(x, y)
    }

    // 3: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
    // Define an inline function here
    public inline fun inline_increment(a: u16): (u16, u16) {
        (a + 10, a + 20)
    }

    public fun call_inline_and_compute(x: u16): u16 {
        let (val1, val2) = inline_increment(x);
        val1 + val2
    }

    // 4: Use identifiers in your Move code where a name is expected.
    struct NamedResource has store, key {
        id: u64,
        name: vector<u8>,
    }

    public fun create_named_resource(s: signer, id: u64, name: vector<u8>) {
        let resource = NamedResource { id, name };
        move_to<NamedResource>(&s, resource);
    }

    public fun read_named_resource_name(s: signer): vector<u8> {
        let resource_ref = borrow_global<NamedResource>(signer::address_of(&s));
        resource_ref.name
    }

    // 5: Write string literals that support escaped characters (such as \" and \\) inside the string.
    public fun string_literals(): vector<u8> {
        // string with escaped double quote and backslash
        let s = b"This is a string with \\ and \" escaped characters";
        s
    }

    // 6: Indicate that a function can generate errors when a function is called from inappropriate locations or contexts.
    public fun error_generating_function(x: u8) acquires NamedResource {
        // Abort with code 100 if x is zero, simulating an error case.
        if (x == 0) {
            abort 100;
        };
        // Abort with code 101 if no NamedResource exists at caller address
        let _ = borrow_global<NamedResource>(0xCAFE); // assume 0xCAFE has it
    }
}


//# run 0xCAFE::TestFeatures::add_two_and_return_sum --args 10u8 5u8


//# run 0xCAFE::TestFeatures::lambda_usage --args 20u8 22u8


//# run 0xCAFE::TestFeatures::call_inline_and_compute --args 7u16


//# run 0xCAFE::TestFeatures::string_literals


//# publish
module 0xCAFE::TestCaller {
    use std::signer;
    use 0xCAFE::TestFeatures;

    public fun call_inline_from_another_module(x: u16): u16 {
        let (a, b) = TestFeatures::inline_increment(x);
        a + b
    }

    public fun call_error_generating_function(x: u8) {
        TestFeatures::error_generating_function(x);
    }

    public fun create_named(s: signer, id: u64, name: vector<u8>) {
        TestFeatures::create_named_resource(s, id, name);
    }

    public fun get_named_name(s: signer): vector<u8> {
        TestFeatures::read_named_resource_name(s)
    }
}


//# run 0xCAFE::TestCaller::call_inline_from_another_module --args 2u16


//# run 0xCAFE::TestCaller::create_named --signers 0xDEAD --args 123u64 b"Alice"




//# run 0xCAFE::TestCaller::get_named_name --signers 0xDEAD



//# run 0xCAFE::TestCaller::call_error_generating_function --args 0u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// b6f33b3c662d4c82c64c45a75ef3b00f: Use identifiers in your Move code where a name is expected.
// dd9eb9a3733e0e74b7e233c25e26ff6b: Write string literals that support escaped characters (such as \" and \\) inside the string.
// 0669c3f7e9953b601f26a43ccebc4602: Indicate that a function can generate errors when a function is called from inappropriate locations or contexts.
