
//# publish
module 0xCAFE::LambdaTest {
    // Removed unused std::vector import

    struct Container<T: copy + drop> has copy, drop {
        value: T
    }

    // Function that adds two u8 values and then returns one more than their sum
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Function demonstrating lambdas: anonymous functions that add and multiply
    public fun lambdas_example(): u8 {
        let add: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let multiply: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x * y
        };
        let added = add(3u8, 4u8);
        let product = multiply(2u8, 5u8);

        added + product
    }

    // Since MyModule::f2 is undefined, here is a dummy implementation inside this module
    // to replace the call and fix compilation/linker errors.
    //
    // Assuming f2 takes u16 and returns a tuple (u16, u16),
    // this matches the usage in nested_inline_call below.
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    // Function uses the inline function f2 from MyModule to get tuple and returns sum
    public fun nested_inline_call(x: u16): u16 {
        let (a, b) = Self::f2(x);
        a + b
    }

    // Example demonstrating Container struct with constraints on type parameter
    public fun create_container_with_u8(val: u8): Container<u8> {
        Container<u8> { value: val }
    }

    public fun create_container_with_bool(val: bool): Container<bool> {
        Container<bool> { value: val }
    }

    public fun container_value_sum(c1: Container<u8>, c2: Container<u8>): u8 {
        c1.value + c2.value
    }
}



//# run 0xCAFE::LambdaTest::add_and_increment --args 10u8 20u8



//# run 0xCAFE::LambdaTest::lambdas_example



//# run 0xCAFE::LambdaTest::nested_inline_call --args 15u16



//# run 0xCAFE::LambdaTest::create_container_with_u8 --args 99u8



//# run 0xCAFE::LambdaTest::create_container_with_bool --args true



//# run 0xCAFE::LambdaTest::container_value_sum --args 12u8 34u8
