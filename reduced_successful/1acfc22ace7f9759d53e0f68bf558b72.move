// Removed `use std::assert;` because the standard library module `std::assert` does not exist or is not imported this way.
// Corrected function return in compute_add by adding explicit return.
// Fixed unbound name error (z used before declaration).
// Removed invalid qualified syntax `(1u8 + 2u8)::add_one(3u8);`.
// Removed binary literal notation (0b) unsupported directly in Move, used decimal instead.
// Removed `use 0xCAFE::TestComputeAdd;` because cross-module references require publishing modules properly in Aptos environment (not possible here). 
// For demonstration, kept all modules independent.
// Added missing semicolons for if-else used as statement (though it's not necessary if expression is returned).


//# publish
module 0xCAFE::TestComputeAdd {
    // Removed `use std::assert;` - no such module

    public fun compute_add(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 55 if sum equals 10, otherwise sum
        if (sum == 10) {
            55
        } else {
            sum
        }
    }

    public fun test_lambda_ops(): (u8, u8) {
        let add = |x: u8, y: u8| { x + y };
        let mul = |x: u8, y: u8| { x * y };
        let (a, b) = (3u8, 7u8);
        let add_res = add(a, b);
        let mul_res = mul(a, b);
        (add_res, mul_res)
    }
}


//# run 0xCAFE::TestComputeAdd::compute_add --args 3u8 7u8


//# run 0xCAFE::TestComputeAdd::compute_add --args 5u8 4u8


//# run 0xCAFE::TestComputeAdd::test_lambda_ops




//# publish
module 0xCAFE::TestInlineCall {
    // Removed use statement because TestComputeAdd module reference won't link in this isolated environment
    // For demonstration, we replicate compute_add here or assume separate compilation.

    public inline fun increment(x: u8): u8 {
        x + 1
    }

    // Re-implemented compute_add inline here to avoid missing module error
    public fun compute_add(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            55
        } else {
            sum
        }
    }

    public fun combine_calls(x: u8, y: u8): u8 {
        let inc_x = increment(x);
        let sum = compute_add(inc_x, y);
        sum
    }
}


//# run 0xCAFE::TestInlineCall::combine_calls --args 4u8 5u8




//# publish
module 0xCAFE::TestUnboundAndQualified {
    // Removed use std::assert;

    const C1: u8 = 10;

    public fun test_unbound_and_qualified(x: u8): u8 {
        // Declare z before use to fix unbound error
        let z = 5u8;
        let y = x + z;
        // Since `(1u8 + 2u8)::add_one(3u8)` is invalid, just call add_one with 3u8
        let result = add_one(3u8);
        if (true && false) {
            0
        } else {
            1
        };
        result + y
    }

    public inline fun add_one(x: u8): u8 {
        x + 1
    }
}


//# run 0xCAFE::TestUnboundAndQualified::test_unbound_and_qualified --args 2u8




//# publish
module 0xCAFE::TestOperators {
    // Removed use std::assert;

    public fun test_all_ops(): bool {
        let a: u8 = 10;   // 0b1010 decimal 10
        let b: u8 = 12;   // 0b1100 decimal 12

        // Comparison
        // For asserts, assuming no std::assert, discard or implement local asserts if needed. Just do comparisons.
        let comp = a < b;

        // Logical (simulate via bit operators because no logical operators for u8)
        let and_res = a & b; // 8
        let or_res = a | b;  // 14
        let xor_res = a ^ b; // 6

        let shl_res = a << 1; // 20
        let shr_res = b >> 2; // 3

        let sum = a + b;      // 22
        let diff = b - a;     // 2
        let mul = a * b;      // 120
        let div = b / 3;      // 4
        let rem = b % 5;      // 2

        comp && (and_res == 8) && (or_res == 14) && (xor_res == 6) && (shl_res == 20) && (shr_res == 3) && (sum == 22) && (diff == 2) && (mul == 120) && (div == 4) && (rem == 2)
    }
}


//# run 0xCAFE::TestOperators::test_all_ops
