
//# publish
module 0xCAFE::LambdaAdd {
    // Function to add two u8 values and return x + y + 1u8 to test addition and return value
    public fun add_then_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = sum + 1;
        result
    }

    // Function that defines a lambda to multiply and add
    public fun lambda_example(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * 2 + y
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::LambdaAdd::add_then_increment --args 10u8 20u8



//# run 0xCAFE::LambdaAdd::lambda_example --args 5u8 3u8



//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::LambdaAdd;

    // Inline function returning a tuple of u32
    public inline fun inline_tuple(a: u32): (u32, u32) {
        (a + 10, a + 20)
    }

    // Function that calls an inline function from LambdaAdd indirectly by arithmetic on the return
    public fun call_nested_functions(x: u8, y: u8): u32 {
        // Use the LambdaAdd add_then_increment function
        let sum = LambdaAdd::add_then_increment(x, y);
        // Use the inline_tuple function
        let (a, b) = inline_tuple((sum as u32));
        a + b
    }
}



//# run 0xCAFE::InlineCallTest::call_nested_functions --args 2u8 3u8



//# publish
module 0xCAFE::DeprecatedAndClosure {
    // Deprecated constant
    // deprecated(reason = "Use NEW_CONST instead")]
    const OLD_CONST: u8 = 1;

    const NEW_CONST: u8 = 2;

    // Deprecated struct
    // deprecated(reason = "Use NewStruct instead")]
    struct OldStruct has copy, drop, store {
        old_field: u8,
    }

    struct NewStruct has copy, drop, store {
        new_field: u8,
    }

    // Deprecated function
    // deprecated(reason = "Use new_function instead")]
    public fun old_function(x: u8): u8 {
        x + OLD_CONST
    }

    public fun new_function(x: u8): u8 {
        x + NEW_CONST
    }

    // Closure that captures an outer variable and returns a closure
    public fun closure_with_capture(x: u8): |u8|u8 has copy+drop {
        // Outer variable
        let captured = x;

        // Return a closure that adds its argument to captured
        |y: u8| (captured + y)
    }

    // Closure that accepts a closure as an argument and applies it twice
    public fun apply_twice(f: &|u8|u8 has copy+drop, val: u8): u8 {
        let first = (*f)(val);
        (*f)(first)
    }

    public fun test_closures(): u8 {
        let closure = closure_with_capture(5u8);
        apply_twice(&closure, 3u8)
    }
}



//# run 0xCAFE::DeprecatedAndClosure::old_function --args 7u8



//# run 0xCAFE::DeprecatedAndClosure::new_function --args 7u8



//# run 0xCAFE::DeprecatedAndClosure::test_closures
