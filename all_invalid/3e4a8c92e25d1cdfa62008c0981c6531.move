
//# publish
module 0xCAFE::PureFunctions {
    use std::vector;

    // This module tests pure functions without side effects.

    // Pure function: computes sum of two u64 values
    public fun sum(a: u64, b: u64): u64 {
        a + b
    }

    // Pure function: computes product of a u8 and a u128, returns u128
    public fun product(a: u8, b: u128): u128 {
        (a as u128) * b
    }

    // Pure function: returns true if two addresses are equal
    public fun equal_addresses(a: address, b: address): bool {
        a == b
    }

    // Pure function: returns true if two bool values are different
    public fun not_equal_bool(a: bool, b: bool): bool {
        a != b
    }

    // Pure function: constant folding test involving equality on u8 literals
    public fun const_fold_eq_u8(): bool {
        (3u8 + 4u8) == 7u8
    }

    // Pure function: constant folding test involving inequality on u64 literals
    public fun const_fold_neq_u64(): bool {
        (10u64 * 2u64) != 15u64
    }

    // Pure function: constant folding test for address equality
    public fun const_fold_eq_address(): bool {
        @0xCAFE == @0xCAFE
    }

    // Pure function: constant folding test for bytearray equality
    public fun const_fold_eq_bytearray(): bool {
        // byte array literals are vector<u8>
        let a = b"abc";
        let b = b"abc";
        vector::equals(&a, &b)
    }
}



//# run 0xCAFE::PureFunctions::sum --args 5u64 7u64



//# run 0xCAFE::PureFunctions::product --args 3u8 100u128



//# run 0xCAFE::PureFunctions::equal_addresses --args 0xCAFE 0xCAFE



//# run 0xCAFE::PureFunctions::not_equal_bool --args true false



//# run 0xCAFE::PureFunctions::const_fold_eq_u8 



//# run 0xCAFE::PureFunctions::const_fold_neq_u64



//# run 0xCAFE::PureFunctions::const_fold_eq_address



//# run 0xCAFE::PureFunctions::const_fold_eq_bytearray




//# publish
module 0xCAFE::LambdaCapture {
    // This module tests use of lambda expressions with lvalue params and captured variables.

    // Public function creating and calling a lambda that captures local variable
    public fun test_lambda_capture(x: u8, y: u8): u8 {
        let captured = x + y;

        let add_captured: |u8|u8 has copy+drop = |z: u8| {
            captured + z
        };

        add_captured(10u8)
    }

    // Lambda that modifies an lvalue parameter by capturing it mutably
    public fun test_lambda_mut_capture(x: u8): u8 {
        let mut_acc = x;
        let adder: |&mut u8|() has drop = |p: &mut u8| {
            *p = *p + 5u8;
        };
        adder(&mut mut_acc);
        mut_acc
    }

    // Runner function calling test_lambda_capture and test_lambda_mut_capture for easy run
    public fun runner(): (u8, u8) {
        let r1 = test_lambda_capture(3u8, 4u8);
        let r2 = test_lambda_mut_capture(7u8);
        (r1, r2)
    }
}



//# run 0xCAFE::LambdaCapture::test_lambda_capture --args 1u8 2u8



//# run 0xCAFE::LambdaCapture::test_lambda_mut_capture --args 10u8



//# run 0xCAFE::LambdaCapture::runner


// Featurres:
// 81a18a867fbc5a86269fd5f8795a2b71: Write move functions without side effects to ensure purity.
// f73060b6d1076a931e5179d4883248f2: Use lambda (anonymous function) expressions with lvalue parameters and captured variables.
// ae2d61bc4b7fc3d0a9c1b3fcd6dbc137: Test that Move supports constant folding and correct evaluation of equality (==) and inequality (!=) comparisons for all primitive types (u8, u64, u128, bool, address, hex, bytearray) at compile time.
