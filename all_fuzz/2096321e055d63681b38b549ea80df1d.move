
//# publish
module 0xCAFE::MyModule {
    /// An inline function that takes a u16 and returns a tuple (u16, u16)
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }

    /// A struct S with field x
    struct S has copy, drop, store {
        x: u32,
    }

    /// A public function to create an S struct - NOT inline (pack only inside defining module)
    public fun f3(val: u16): S {
        S { x: val as u32 }
    }

    /// Accessor to get the x field from S - needed so other modules cannot access field directly
    public fun get_x(s: &S): u32 {
        s.x
    }
}



//# publish
module 0xCAFE::LambdaModule {
    /// Adds two u8 numbers and then returns their sum plus 10.
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;

        // Return sum + 10
        sum + 10
    }

    /// Function that defines a lambda to multiply two u8 and returns the product plus 5.
    public fun lambda_multiply_plus_five(a: u8, b: u8): u8 {
        let multiply: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let prod = multiply(a, b);
        prod + 5
    }

    /// Function that returns a lambda that adds 1 to the argument.
    public fun get_increment_lambda(): |u8| u8 has copy+drop {
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            x + 1
        };
        lambda
    }

    /// Runner function to call add_then_return with preset values
    public fun runner_add_then_return(): u8 {
        add_then_return(3u8, 7u8)
    }
}



//# publish
module 0xCAFE::CallInlineModule {
    use 0xCAFE::MyModule;

    /// Calls MyModule::f2 inline function and sums the returned tuple components.
    public fun call_inline_and_sum(a: u16): u16 {
        let (x, y) = MyModule::f2(a);
        x + y
    }

    /// Calls MyModule::f3 function (not inline) and returns field x from the S struct via accessor.
    public fun call_f3_and_get_x(val: u16): u32 {
        // Call MyModule::f3 to get S struct
        let s = MyModule::f3(val);
        // Access field x via MyModule::get_x since direct field access is disallowed outside defining module
        MyModule::get_x(&s)
    }

    /// Runner that calls call_inline_and_sum and call_f3_and_get_x with preset values and returns sum of results cast to u64.
    public fun runner_combined(): u64 {
        let x = call_inline_and_sum(20u16) as u64;
        let y = call_f3_and_get_x(15u16) as u64;
        x + y
    }
}




//# run 0xCAFE::LambdaModule::add_then_return --args 10u8 5u8




//# run 0xCAFE::LambdaModule::lambda_multiply_plus_five --args 4u8 3u8




//# run 0xCAFE::LambdaModule::get_increment_lambda




//# run 0xCAFE::LambdaModule::runner_add_then_return




//# run 0xCAFE::CallInlineModule::call_inline_and_sum --args 50u16




//# run 0xCAFE::CallInlineModule::call_f3_and_get_x --args 25u16




//# run 0xCAFE::CallInlineModule::runner_combined
