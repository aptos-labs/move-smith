
//# publish
module 0xCAFE::TestFeatures {
    use std::vector;

    /// Function that adds two u8 and then returns 42
    public fun add_and_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42, sum is used internally.
        42
    }

    /// Function that accepts a lambda to add two u8 and returns the result
    public fun test_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        adder(a, b)
    }

    /// Inline function that returns a tuple of two u16 values
    public inline fun f2(x: u16): (u16, u16) {
        (x, 2 * x)
    }

    /// Function that calls the inline function f2 and returns sum of tuple elements
    public fun nested_inline_call(x: u16): u16 {
        let (a, b) = f2(x);
        a + b
    }

    /// Function showing vector construction and returns vector length
    public fun vector_example(): u64 {
        let v1: vector<u8> = vector[1u8, 2u8, 3u8];
        let v2: vector<u8> = vector[];
        let v3: vector<u16> = vector[0u16, 5u16];
        let v4: vector<u64> = vector[];

        // length of vector v1 == 3
        (vector::length(&v1)) as u64
    }
}



//# run 0xCAFE::TestFeatures::add_and_return_42 --args 10u8 32u8


//# run 0xCAFE::TestFeatures::test_lambda --args 10u8 32u8


//# run 0xCAFE::TestFeatures::nested_inline_call --args 10u16


//# run 0xCAFE::TestFeatures::vector_example
