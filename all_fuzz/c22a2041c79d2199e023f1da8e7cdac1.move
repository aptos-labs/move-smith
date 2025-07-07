
//# publish
module 0xCAFE::AddAndLambda {
    // Removed the use of 0xCAFE::MyModule because it does not exist
    // use 0xCAFE::MyModule;

    // Defines a struct with abilities copy and drop
    struct AbledStruct has copy, drop {
        a: u8,
        b: u8,
    }

    // Adds two u8 and returns the sum
    public fun add_two(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    // Defines and calls a lambda to multiply two u8 numbers, returns u8
    public fun lambda_multiply(x: u8, y: u8): u8 {
        let mul_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a * b
        };
        mul_lambda(x, y)
    }

    // Because 0xCAFE::MyModule does not exist, re-implement f2 inline here
    // Example implementation of f2: given a u16 input, return a tuple (input, input * 2)
    public fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }

    // Calls the inline function f2 and returns the first tuple element
    public fun call_inline_and_return_first(a: u16): u16 {
        let (first, _second) = Self::f2(a);
        first
    }

    // Uses variable identifiers that resemble keywords and numbers
    public fun parse_var_idents() {
        let x0 = 5u8;
        let x1 = 10u8;
        let if_ = 7u8;
        let else_ = 8u8;
        let match_ = 9u8;
        let sum1 = x0 + x1 + if_ + else_ + match_;
        // To avoid warnings of unused variable, you could add:
        // sum1;
    }
}



//# run 0xCAFE::AddAndLambda::add_two --args 12u8 34u8



//# run 0xCAFE::AddAndLambda::lambda_multiply --args 6u8 7u8



//# run 0xCAFE::AddAndLambda::call_inline_and_return_first --args 11u16



//# run 0xCAFE::AddAndLambda::parse_var_idents
