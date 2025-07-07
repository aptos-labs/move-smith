
//# publish
module 0xCAFE::ComplexFeaturesTest {
    // Removed unused import 'std::signer'

    // 4: Add type constraints to struct type parameters
    struct Container<T: copy + drop> has store {
        value: T
    }

    // 5: Define struct types with abilities and type parameters and layout annotations
    // layout(packed)]
    struct PackedPair<T: copy, U: copy> has copy, drop, store {
        first: T,
        second: U,
    }

    // 1: Function computing addition of two u8 values returning a fixed value
    public fun add_and_return_fixed(_x: u8, _y: u8): u8 {
        // suppressed unused variable warning by prefixing _ 
        let _sum = _x + _y;
        let fixed_value = 42u8;
        fixed_value
    }

    // 2: Function containing lambda (anonymous function) expressions
    public fun test_lambda_ops(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy = |a: u8, b: u8| { a + b };
        let mul_lambda: |u8, u8| u8 has copy = |a: u8, b: u8| { a * b };

        let sum = add_lambda(x, y);
        let product = mul_lambda(x, y);

        sum + product
    }

    // Inline function used for nested calls
    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    // 3: Call inline function of this module from another module
    public fun nested_inline_call(x: u8): u8 {
        let y = inline_increment(x);
        let z = inline_increment(y);
        z
    }

    // Function to create and return Container holding PackedPair<u8, u8>
    public fun create_container_pair(a: u8, b: u8): Container<PackedPair<u8, u8>> {
        let pair = PackedPair {first: a, second: b};
        Container {value: pair}
    }

    // Runner function with no arguments
    public fun runner() {
        let _ = add_and_return_fixed(10u8, 20u8);

        let _ = test_lambda_ops(3u8, 4u8);

        let _ = nested_inline_call(5u8);

        let container = create_container_pair(7u8, 8u8);
        // Consume 'container' value since Container<PackedPair<u8, u8>> does not have 'drop' ability.
        // We can unpack Container to consume it:
        let Container { value: pair } = container;
        // Also unpack pair, although it's copy+drop, but just to consume:
        let PackedPair { first: _first, second: _second } = pair;
    }
}



//# run 0xCAFE::ComplexFeaturesTest::runner



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::ComplexFeaturesTest;

    public fun call_nested(x: u8): u8 {
        ComplexFeaturesTest::nested_inline_call(x)
    }
}



//# run 0xCAFE::CallerModule::call_nested --args 10u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 46c9b97e99d80c136ca51c5f26d07474: Add type constraints to struct type parameters
// 493ce8035e7ebc0a810f21e355e065e9: Define struct types with attributes, abilities, type parameters, and layout annotations.
