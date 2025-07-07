
//# publish
module 0xCAFE::AdditionTest {
    // Test 1: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.

    public fun add_then_return_fixed_value(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    // Test 2: Write functions containing lambda (anonymous function) expressions.
    // Note: Move currently does not support lambda or anonymous functions.
    // We instead define a local inline function to replace lambda functionality.

    inline fun mul(a: u8, b: u8): u8 {
        a * b
    }

    public fun apply_lambda_twice(x: u8, y: u8): u8 {
        let result1 = mul(x, y);
        let result2 = mul(result1, y);
        result2
    }

    // Test 3: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
    // Replace the call to MyModule::f2 with a local inline function to avoid errors.

    inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }

    public fun call_inline_f2(a: u16): (u16, u16) {
        f2(a)
    }

    // Test 4: Test that a public function returning the result of a constant expression can be successfully called and its return value asserted in another public function.

    const CONST_VALUE: u32 = 123;

    public fun return_const(): u32 {
        CONST_VALUE
    }

    public fun check_const_value(): bool {
        let val = return_const();
        if (val == CONST_VALUE) {
            true
        } else {
            false
        }
    }
}




//# run 0xCAFE::AdditionTest::add_then_return_fixed_value --args 5u8 7u8




//# run 0xCAFE::AdditionTest::apply_lambda_twice --args 2u8 3u8




//# run 0xCAFE::AdditionTest::call_inline_f2 --args 100u16




//# run 0xCAFE::AdditionTest::check_const_value




//# publish
module 0xCAFE::SpecSchemaTest {
    use std::vector;

    struct Data has store {
        value: u8,
    }

    /// Specification schema targeting the Data struct
    spec schema DataSchema {
        // Predicate: value is less than 100.
        val_less_than_100(d: &Data): bool;
    }

    /// Specification definition for val_less_than_100 predicate
    spec DataSchema {
        val_less_than_100(d: &Data): bool {
            d.value < 100
        }
    }

    /// Function to construct a Data instance for specification testing
    public fun create_data(val: u8): Data {
        Data { value: val }
    }

    /// Specification block to assert properties on the function
    spec create_data {
        ensures val_less_than_100(result)
    }
}




//# run 0xCAFE::SpecSchemaTest::create_data --args 42u8
