
//# publish
module 0xCAFE::ComputeAdd {
    // Test function that adds two u8 values and returns the sum + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function that contains lambda expressions and returns their results combined
    public fun lambda_operations(x: u8, y: u8): (u8, u8) {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        let multiplier: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a * b;

        let added = adder(x, y);
        let multiplied = multiplier(x, y);
        (added, multiplied)
    }

    // Struct with regular named fields
    struct RegularFields has copy, drop, store {
        x: u8,
        y: u8,
    }

    // Struct with positional fields by using unnamed fields in declaration (using tuple struct style)
    // But as per Move syntax, tuple structs are not allowed, so simulate with named fields in order
    struct PositionalFields has copy, drop, store {
        _0: u8,
        _1: u8,
    }

    // Function to create and return a RegularFields struct
    public fun create_regular(x: u8, y: u8): RegularFields {
        RegularFields { x, y }
    }

    // Function to create and return a PositionalFields struct
    public fun create_positional(x: u8, y: u8): PositionalFields {
        PositionalFields { _0: x, _1: y }
    }

    // Example of invalid use of attribute (WARNING): @copy used nested inside function - invalid position
    // The attribute usage is placed improperly to check that compiler warns/errors it
    // (this is just for the test, so no usage of the annotated function)
    public fun invalid_attribute_usage() {
        // This is a dummy function to simulate attribute misuse (no effect on execution)
        // Token `@copy` nested inside function - NOT ALLOWED - should be outside at struct or function level
        // Here intentionally incorrect:
        // @copy
        let dummy: u8 = 1;
    }
}


//# run 0xCAFE::ComputeAdd::add_and_offset --args 3u8 5u8


//# run 0xCAFE::ComputeAdd::lambda_operations --args 4u8 6u8


//# run 0xCAFE::ComputeAdd::create_regular --args 7u8 8u8


//# run 0xCAFE::ComputeAdd::create_positional --args 9u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 0a4bf8b517a6f7a4362afc75ce952189: Declare structs with fields either as regular or positional fields.
// 28e3cac7cfb6fd855decf014568a084c: Identify and warn about attributes used in incorrect positions, such as nested attributes where they are not expected.
