
//# publish
module 0xCAFE::LambdaTest {
    // LambdaTest tests various lambda and inline function features

    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun add_two_values(x: u8, y: u8): u8 {
        // lambda to add two u8 values
        let add_lambda: |u8, u8|u8 has copy = |m: u8, n: u8| {
            m + n
        };
        let sum = add_lambda(x, y);

        // return sum + 1 as specific value to test +1 after addition
        sum + 1
    }

    public fun produce_pair(x: u8, y: u8): Pair {
        Pair { a: x, b: y }
    }

    // Inline function returns sum of two u8s
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        // call inline_add from this module
        let sum_inline = inline_add(x, y);

        // lambda doubles the sum
        let double_lambda: |u8| u8 has copy = |v: u8| {
            v * 2
        };
        let result = double_lambda(sum_inline);

        result
    }

    public fun access_fields_and_index(x: u8, y: u8): (u8, u8, u8) {
        let p = produce_pair(x, y);

        // Access dotted fields
        let a_val = p.a;
        let b_val = p.b;

        let byte_vec = b"abcde";

        // Index the vector (safe because length >= 5)
        let indexed_char = *std::vector::borrow(&byte_vec, 2);

        (a_val, b_val, indexed_char)
    }
}


//# run 0xCAFE::LambdaTest::add_two_values --args 10u8 15u8


//# run 0xCAFE::LambdaTest::call_inline_and_lambda --args 5u8 7u8


//# run 0xCAFE::LambdaTest::access_fields_and_index --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 6a39ccb0349058f05657fa531445d8b6: Access dotted or indexed data with `ExpDotted` and `Index` expressions.
// 44c581ac2d6f93070719f88426073f6d: Use ASCII characters only in byte strings.
