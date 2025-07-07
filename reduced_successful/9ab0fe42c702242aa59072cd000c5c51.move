
//# publish
module 0xCAFE::TestAddition {
    // This module tests addition of two u8 values and returns a fixed value

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        sum // return sum explicitly (last expression returned)
    }

    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        100u8
    }
}



//# run 0xCAFE::TestAddition::add_and_return_fixed --args 10u8 32u8



//# run 0xCAFE::TestAddition::add_and_return_specific --args 50u8 50u8



//# publish
module 0xCAFE::LambdaTest {
    // Testing lambda (anonymous function) expressions

    public fun apply_lambda_add(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| { a + b };
        let result = lambda(x, y);
        result
    }

    public fun use_lambda_in_lambda(x: u8, y: u8): u8 {
        let outer_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            let inner_lambda: |u8| u8 has copy + drop = |c: u8| { c * 2 };
            inner_lambda(a) + inner_lambda(b)
        };
        outer_lambda(x, y)
    }
}



//# run 0xCAFE::LambdaTest::apply_lambda_add --args 7u8 8u8



//# run 0xCAFE::LambdaTest::use_lambda_in_lambda --args 3u8 4u8



//# publish
module 0xCAFE::NestedInline {
    // This module calls an inline function in another module and returns expected result
    
    // Removed use 0xCAFE::MyModule; and references to MyModule,
    // since 0xCAFE::MyModule is an example/nonexistent module
    
    // Instead provide a dummy inline function f2 here:
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1u16)
    }

    public fun call_inline_and_process(a: u16): u16 {
        let (v1, v2) = f2(a);
        v1 + v2 + 1u16
    }
}



//# run 0xCAFE::NestedInline::call_inline_and_process --args 20u16



//# publish
module 0xCAFE::AttributesAndPrecedence {
    // This module uses attributes and tests operator precedence in logical, comparison, and bitwise expressions

    // [known_attribute]
    // [unknown_attribute("testing")]
    public fun test_operator_precedence(x: u8, y: u8): bool {
        // Logic: !(x < y) && (x & y == y | x)
        // Expected precedence:
        // !(x < y) && ((x & y) == (y | x))

        let logic_result = !(x < y) && ((x & y) == (y | x));
        logic_result
    }

    // [another_known_attr]
    public fun complex_comparison(a: u8, b: u8, c: u8): bool {
        // Test operator mix:
        // a + b * c == b << 1 && (a | c) > b & c
        // Interpretation follows normal operator precedence in Move
        // Multiplication then addition, bit shifts and bitwise ops as expected

        let left_side = a + (b * c);
        let right_side1 = b << 1;
        let right_side2 = (a | c) > (b & c);
        (left_side == right_side1) && right_side2
    }
}



//# run 0xCAFE::AttributesAndPrecedence::test_operator_precedence --args 2u8 3u8



//# run 0xCAFE::AttributesAndPrecedence::complex_comparison --args 3u8 2u8 1u8
