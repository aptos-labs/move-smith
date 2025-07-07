
//# publish
module 0xCAFE::TestFeatures {
    use std::vector;

    // A function that computes the addition of two u8 values and returns the sum + 10.
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // A public function that contains a lambda (anonymous function) expression that increments a u8 by 1.
    public fun lambda_increment(x: u8): u8 {
        let increment: |u8|u8 has copy+drop = |val: u8| {
            val + 1
        };
        increment(x)
    }

    // An inline function returns a tuple (u16, u16)
    public inline fun inline_tuple(a: u16): (u16, u16) {
        (a + 5, a + 10)
    }

    // Phantom type struct: U is unused phantom generic parameter.
    struct PhantomStruct<T, U> has copy, drop {
        field_t: T,
        // no field of type U to present phantom use
    }

    // A function that creates a PhantomStruct and returns field_t
    public fun create_phantom_and_get_field(a: u8): u8 {
        let structure = PhantomStruct<u8, vector<u8>> { field_t: a };
        structure.field_t
    }
}


//# publish
module 0xCAFE::TestUsage {
    use 0xCAFE::TestFeatures;

    // Calls add_with_offset with 3u8 and 4u8, expects 3+4+10=17
    public fun call_add(): u8 {
        TestFeatures::add_with_offset(3u8, 4u8)
    }

    // Calls the lambda_increment function in TestFeatures to test lambda execution
    public fun call_lambda(x: u8): u8 {
        TestFeatures::lambda_increment(x)
    }

    // Calls the inline function returning a tuple and returns sum of both tuple values as u32
    public fun inline_nested(a: u16): u32 {
        let (x, y) = TestFeatures::inline_tuple(a);
        let sum = (x as u32) + (y as u32);
        sum
    }

    // Calls phantom type usage function from TestFeatures
    public fun phantom_test(a: u8): u8 {
        TestFeatures::create_phantom_and_get_field(a)
    }
}


//# run 0xCAFE::TestFeatures::add_with_offset --args 10u8 15u8


//# run 0xCAFE::TestFeatures::lambda_increment --args 20u8


//# run 0xCAFE::TestUsage::call_add


//# run 0xCAFE::TestUsage::call_lambda --args 99u8


//# run 0xCAFE::TestUsage::inline_nested --args 7u16


//# run 0xCAFE::TestUsage::phantom_test --args 77u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 091ca4ee08a1cbc4b5275c01037467b4: Use phantom type parameters to indicate unused generic parameters.
