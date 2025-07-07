
//# publish
module 0xCAFE::Adder {
    public fun add_values(a: u8, b: u8): u8 {
        let _sum = a + b;
        // Return fixed value 42 to test control flow after addition
        42
    }

    public fun call_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::Adder::add_values --args 5u8 7u8



//# run 0xCAFE::Adder::call_lambda --args 6u8 9u8



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    // Inline function f2 replacement - returns tuple (u16, u16)
    public fun f2(x: u16): (u16, u16) {
        (x * 2, x + 3)
    }

    // Calls an inline function f2 then uses the result in Adder
    public fun nested_function_calls(x: u16, a: u8, b: u8): u8 {
        let (val1, _val2) = Self::f2(x);
        let _ = _val2; // explicitly use _val2 to avoid unused variable warning
        let sum = a + b;
        let res1 = Adder::call_lambda(a, b);
        // add the lower 8 bits of val1 to the lambda result
        let val1_lower8 = (val1 & 0xFF) as u8;
        val1_lower8 + res1 + (sum as u8)
    }

    public fun runner(): u8 {
        nested_function_calls(10u16, 2u8, 3u8)
    }
}



//# run 0xCAFE::NestedCalls::nested_function_calls --args 10u16 4u8 5u8



//# run 0xCAFE::NestedCalls::runner
