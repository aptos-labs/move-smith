
//# publish
module 0xCAFE::TestLambda {
    // Testing lambda expressions and addition of two u8 values

    // Returns the sum of two u8s plus a fixed offset 42u8
    public fun add_two_values(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = lambda(a, b);
        let unused_var = 100u8; // unused local variable
        sum + 42u8
    }

    public fun lambda_with_capture(x: u8): u8 {
        let captured = 10u8;
        let adder: |u8| u8 has copy+drop = |y: u8| {
            x + y + captured
        };
        adder(5u8)
    }
}


//# run 0xCAFE::TestLambda::add_two_values --args 3u8 4u8


//# run 0xCAFE::TestLambda::lambda_with_capture --args 7u8



//# publish
module 0xCAFE::TestInlineCalls {
    use 0xCAFE::TestLambda;

    const OFFSET: u8 = 5u8;
    const CONST_U64: u64 = 123456789u64;

    // Calls add_two_values from TestLambda with fixed arguments then adds OFFSET
    public fun test_nested_calls(): u8 {
        let base = TestLambda::add_two_values(1u8, 2u8);
        let result = base + OFFSET;
        result
    }

    // Calls lambda_with_capture and adds 3u8
    public fun another_test(): u8 {
        let val = TestLambda::lambda_with_capture(8u8);
        let unused_local = 99u8;
        val + 3u8
    }

    // Function that declares many locals with built-in types, does nothing with them.
    public fun builtin_types_local_vars(): bool {
        let _b: bool = true;
        let _u8: u8 = 1u8;
        let _u64: u64 = 10u64;
        let _u128: u128 = 100u128;
        let _address: address = @0xCAFE;
        let _vector_u8: vector<u8> = b"abc";
        let _vector_address: vector<address> = vector[@0x1, @0x2];
        true
    }
}


//# run 0xCAFE::TestInlineCalls::test_nested_calls


//# run 0xCAFE::TestInlineCalls::another_test


//# run 0xCAFE::TestInlineCalls::builtin_types_local_vars



//# publish
module 0xCAFE::ConstTester {
    // constants of various types
    const CONST_ONE: u8 = 1u8;
    const CONST_BIG: u64 = 9223372036854775807u64;
    const CONST_BOOL: bool = true;
    const CONST_ADDRESS: address = @0xCAFE;
    const CONST_VECTOR: vector<u8> = b"const";

    public fun get_const_one(): u8 {
        CONST_ONE
    }

    public fun get_const_big(): u64 {
        CONST_BIG
    }

    public fun get_const_bool(): bool {
        CONST_BOOL
    }

    public fun get_const_address(): address {
        CONST_ADDRESS
    }

    public fun get_const_vector(): vector<u8> {
        CONST_VECTOR
    }
}


//# run 0xCAFE::ConstTester::get_const_one


//# run 0xCAFE::ConstTester::get_const_big


//# run 0xCAFE::ConstTester::get_const_bool


//# run 0xCAFE::ConstTester::get_const_address


//# run 0xCAFE::ConstTester::get_const_vector


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 43decab72d3996ee1fd6ec7c4ee19d49: Test that a function can perform computations with unused local variables and still correctly return its intended value.
// 9eae8a3032e0227f4ac7acdfcbcd6a5d: Refer to all built-in type names available in Move.
// cef92f7a645ac4c90856fea8bcbe1cdb: Define constants as members of a module
