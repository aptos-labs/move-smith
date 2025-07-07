
//# publish
module 0xCAFE::AddU8 {
    // Function that adds two u8 and returns the result plus a constant 10u8
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    // Lambda expression returning a function that doubles a u8 value
    public fun make_doubler(): |u8| u8 {
        let doubler = |x: u8| {
            x * 2u8
        };
        doubler
    }

    // Inline function returns a tuple of increment and decrement of input u8
    public inline fun inc_dec(x: u8): (u8, u8) {
        (x + 1u8, x - 1u8)
    }

    // Private constant cannot be accessed outside (empty visibility)
    const PRIVATE_CONST: u8 = 42;
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddU8;

    // Public function calling inline function from AddU8 multiple times and sums results
    public fun nested_calls(x: u8): u8 {
        let (inc_x, dec_x) = AddU8::inc_dec(x);
        let (inc_inc_x, _dec_dec_x) = AddU8::inc_dec(inc_x);
        inc_x + dec_x + inc_inc_x
    }
}


//# publish
module 0xCAFE::CompareAll {
    // Function to test all comparison operators for all unsigned integer types
    public fun test_comparisons(): bool {
        let a_u8: u8 = 5u8;
        let b_u8: u8 = 6u8;
        let c_u8: u8 = 5u8;

        let a_u16: u16 = 500u16;
        let b_u16: u16 = 600u16;
        let c_u16: u16 = 500u16;

        let a_u32: u32 = 5000u32;
        let b_u32: u32 = 6000u32;
        let c_u32: u32 = 5000u32;

        let a_u64: u64 = 50000u64;
        let b_u64: u64 = 60000u64;
        let c_u64: u64 = 50000u64;

        let a_u128: u128 = 500000u128;
        let b_u128: u128 = 600000u128;
        let c_u128: u128 = 500000u128;

        let a_u256: u256 = 5000000u256;
        let b_u256: u256 = 6000000u256;
        let c_u256: u256 = 5000000u256;

        // Check equality
        let eq1 = (a_u8 == c_u8) && !(a_u8 != c_u8);
        let eq2 = (a_u16 == c_u16) && !(a_u16 != c_u16);
        let eq3 = (a_u32 == c_u32) && !(a_u32 != c_u32);
        let eq4 = (a_u64 == c_u64) && !(a_u64 != c_u64);
        let eq5 = (a_u128 == c_u128) && !(a_u128 != c_u128);
        let eq6 = (a_u256 == c_u256) && !(a_u256 != c_u256);

        // Check less than and less equal
        let lt1 = (a_u8 < b_u8) && (a_u8 <= b_u8) && !(b_u8 < a_u8);
        let lt2 = (a_u16 < b_u16) && (a_u16 <= b_u16) && !(b_u16 < a_u16);
        let lt3 = (a_u32 < b_u32) && (a_u32 <= b_u32) && !(b_u32 < a_u32);
        let lt4 = (a_u64 < b_u64) && (a_u64 <= b_u64) && !(b_u64 < a_u64);
        let lt5 = (a_u128 < b_u128) && (a_u128 <= b_u128) && !(b_u128 < a_u128);
        let lt6 = (a_u256 < b_u256) && (a_u256 <= b_u256) && !(b_u256 < a_u256);

        // Check greater than and greater equal
        let gt1 = (b_u8 > a_u8) && (b_u8 >= a_u8) && !(a_u8 > b_u8);
        let gt2 = (b_u16 > a_u16) && (b_u16 >= a_u16) && !(a_u16 > b_u16);
        let gt3 = (b_u32 > a_u32) && (b_u32 >= a_u32) && !(a_u32 > b_u32);
        let gt4 = (b_u64 > a_u64) && (b_u64 >= a_u64) && !(a_u64 > b_u64);
        let gt5 = (b_u128 > a_u128) && (b_u128 >= a_u128) && !(a_u128 > b_u128);
        let gt6 = (b_u256 > a_u256) && (b_u256 >= a_u256) && !(a_u256 > b_u256);

        eq1 && eq2 && eq3 && eq4 && eq5 && eq6 &&
        lt1 && lt2 && lt3 && lt4 && lt5 && lt6 &&
        gt1 && gt2 && gt3 && gt4 && gt5 && gt6
    }
}


//# publish
module 0xCAFE::CondBranch {
    // This function tests conditional branches with if-else returning different u8 values.
    public fun conditional_branch_test(cond: bool): u8 {
        if (cond) {
            1u8
        } else {
            2u8
        };
    }
}


//# run 0xCAFE::AddU8::add_and_offset --args 4u8 5u8


//# run 0xCAFE::AddU8::make_doubler


//# run 0xCAFE::NestedCalls::nested_calls --args 10u8


//# run 0xCAFE::CompareAll::test_comparisons


//# run 0xCAFE::CondBranch::conditional_branch_test --args true


//# run 0xCAFE::CondBranch::conditional_branch_test --args false


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 7553b3396efb5ff4938a88b0a953cbe8: Test all comparison operators (==, !=, <, >, <=, >=) for all unsigned integer types (u8, u16, u32, u64, u128, u256) to ensure they behave correctly for equal, lesser, and greater values.
// 14993c742de74b563f9623fbba7a7bb3: Use conditional branches that direct control flow to one of two labels based on a condition in Move bytecode.
// 1da9787c21ebf3b362194518d2ece4ca: Make an item private and inaccessible outside its module with an empty visibility modifier.
