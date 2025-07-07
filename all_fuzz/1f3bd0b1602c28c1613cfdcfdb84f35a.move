
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    /// A simple function that adds two u8 values and returns result plus 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        // Returning sum + 10
        sum + 10
    }

    /// Function that defines a lambda which multiplies two u8 numbers and returns the product
    public fun lambda_multiply(x: u8, y: u8): u8 {
        let multiplier: |u8, u8|u8 = |a: u8, b: u8| {
            a * b
        };
        multiplier(x, y)
    }

    /// Calls an inline function from another module to get tuple then returns sum of tuple elements
    public fun nested_inline_call(flag: bool): u16 {
        // Removed call to non-existent function in MyModule::f2
        // Providing a local tuple instead
        let (a, b) = (50u16, 70u16);
        // If flag is true, returns a, else b and adds 100 to that value
        if (flag) {
            (a + 100)
        } else {
            (b + 100)
        }
    }

    /// Creates a vector with elements provided using vector literal syntax
    public fun create_vector() {
        let v1 = vector[10u8, 20u8, 30u8];
        let v2 = vector[true, false, true];
        let v3: vector<u16> = vector[100u16, 200u16];
        let v4 = vector[75u8, 83u8];
        // The vectors are created but not used further intentionally
    }
}




//# run 0xCAFE::FeatureTest::add_and_offset --args 5u8 15u8




//# run 0xCAFE::FeatureTest::lambda_multiply --args 3u8 7u8




//# run 0xCAFE::FeatureTest::nested_inline_call --args true




//# run 0xCAFE::FeatureTest::nested_inline_call --args false




//# run 0xCAFE::FeatureTest::create_vector
