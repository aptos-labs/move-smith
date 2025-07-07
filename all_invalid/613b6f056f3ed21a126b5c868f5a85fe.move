
//# publish
module 0xCAFE::ClosureShadowTest {
    use std::signer;

    struct Counter has store {
        val: u8,
        prop: bool,
    }

    // Function `foo` takes a closure that captures and modifies x by shadowing.
    public fun foo(x: u8, mut_closure: |u8| u8): u8 {
        let x = x;
        // Call the closure with x, expect it modifies the value and returns new value
        mut_closure(x)
    }

    // Runner function to test the inner closure capturing and modifying outer variable with shadowing.
    public fun test_shadowing(): u8 {
        let x = 1u8;

        // Closure captures x and shadows it inside
        let inner_f = |val: u8| {
            let x = val + 2u8; // shadow x by adding 2
            x
        };

        let new_x = foo(x, inner_f);
        new_x
    }

    // Function accepting multiple comma separated arguments and returns their sum
    public fun multi_args(a: u8, b: u8, c: u8): u8 {
        a + b + c
    }

    // A property struct with properties and expressions
    struct PropertySet has copy, drop, store {
        prop1: bool,
        count: u8,
        valid: bool,
    }

    // Function to create and return property set
    public fun create_property_set(p: bool, c: u8): PropertySet {
        PropertySet {
            prop1: p,
            count: c,
            valid: (c > 5u8)
        }
    }

    // Annotate a condition with one or more properties using square brackets
    public fun annotated_if(x: u8): u8 {
        let res = if ([x > 2u8, x < 10u8]) {
            100u8
        } else {
            0u8
        };
        res
    }

    // Validate each character in a byte sequence is permitted by criteria:
    // here we allow only ASCII digits and letters.
    public fun validate_bytes(bytes: vector<u8>): bool {
        let i = 0;
        let len = std::vector::length(&bytes);

        while (i < len) {
            let b = *std::vector::borrow(&bytes, i);
            let is_digit = b >= 48u8 && b <= 57u8;  // '0'..'9'
            let is_uppercase = b >= 65u8 && b <= 90u8; // 'A'..'Z'
            let is_lowercase = b >= 97u8 && b <= 122u8; // 'a'..'z'

            assert!((is_digit || is_uppercase || is_lowercase), 7777);

            i = i + 1;
        };
        true
    }

    // Function demonstrating match arms with block and single expression.
    public fun match_expr(n: u8): u8 {
        match (n) {
            0 => {
                0
            }
            1 => 1,
            _ => {
                let x = n + 1;
                x
            }
        }
    }
}


//# run 0xCAFE::ClosureShadowTest::test_shadowing


//# run 0xCAFE::ClosureShadowTest::multi_args --args 1u8 2u8 3u8


//# run 0xCAFE::ClosureShadowTest::create_property_set --args true 7u8


//# run 0xCAFE::ClosureShadowTest::annotated_if --args 5u8


//# run 0xCAFE::ClosureShadowTest::validate_bytes --args b"Test123"


//# run 0xCAFE::ClosureShadowTest::match_expr --args 0u8


//# run 0xCAFE::ClosureShadowTest::match_expr --args 1u8


//# run 0xCAFE::ClosureShadowTest::match_expr --args 5u8


// Featurres:
// 5b419bfb309cdf2d1d8022392b3e2362: Verify that the inner function passed to 'foo' can correctly access and modify the outer variable 'x' through shadowing or capturing, ensuring the value of 'x' updates to 3 after the function call.
// 57d55d8653679e23d17052be8fcc17cc: Write multiple call arguments separated by commas.
// 9d3b3d0c615b5d24a1d41996a344f527: Include property sets with properties and expressions.
// 6a92a012959641e21785876cf7955ab5: Annotate conditions with one or more properties using square brackets
// c0b78578eb3e13abcdf56b70cfdfafe4: Validate that each character in a byte sequence is permitted according to specific criteria
// 854f81617e84b9895feb9ed044a5d0b8: Include an expression as the body of a match arm, which can be a block or a single expression.
