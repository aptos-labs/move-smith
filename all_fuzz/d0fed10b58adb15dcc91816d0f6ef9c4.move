
//# publish
module 0xCAFE::MathModule {
    // Simple addition function for u8 values followed by a fixed constant addition
    public fun add_then_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    // Function containing a lambda expression that multiplies two u8 numbers
    public fun multiply_lambda(a: u8, b: u8): u8 {
        let multiply: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        multiply(a, b)
    }
}



//# publish
module 0xCAFE::MyModule {
    // Inline function f2 takes u16 and returns a tuple (u16, u16)
    public inline fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;
    use 0xCAFE::MyModule;

    // Calls inline function f2 from 0xCAFE::MyModule and adds results
    // f2 takes u16 and returns tuple (u16, u16)
    // Returns sum of those tuple elements plus the passed argument
    public fun call_inline_and_add(a: u16): u16 {
        let (x, y) = MyModule::f2(a);
        x + y + a
    }

    // Function that calls nested Move functions starting from MathModule -> MyModule inline
    public fun nested_calls(a: u8, b: u8, c: u16): (u8, u16) {
        let add_result = MathModule::add_then_constant(a, b);
        let inline_result = call_inline_and_add(c);
        (add_result, inline_result)
    }
}



//# run 0xCAFE::MathModule::add_then_constant --args 3u8 4u8



//# run 0xCAFE::MathModule::multiply_lambda --args 5u8 6u8



//# run 0xCAFE::CallerModule::call_inline_and_add --args 10u16



//# run 0xCAFE::CallerModule::nested_calls --args 3u8 4u8 5u16
