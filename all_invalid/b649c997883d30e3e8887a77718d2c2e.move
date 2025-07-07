//# publish
module 0xCAFE::InlineAndLambda {
    // Test specifying function name with type parameters explicitly
    public fun add_u8(x: u8, y: u8): u8 {
        x + y
    }

    public fun add_u16(x: u16, y: u16): u16 {
        x + y
    }

    // Inline function with type parameter T, returns identity
    public inline fun identity<T>(value: T): T {
        value
    }

    // Inline function that adds two u16 and calls the inline function identity
    public inline fun sum_identity(a: u16, b: u16): u16 {
        let s = a + b;
        identity<u16>(s)
    }

    // Function demonstrating a lambda that captures nothing and returns u8
    public fun lambda_empty_capture(x: u8): u8 {
        let f: |()| u8 has copy+drop = || { x + 1 };
        f()
    }

    // Function demonstrating a lambda with an explicit capture of a variable
    public fun lambda_with_capture(x: u8): u8 {
        let captured = 5u8;
        // capture by copy happens implicitly by copying captured variable into lambda
        let f: |()| u8 has copy+drop = || { x + captured };
        f()
    }

    // Function that shows nested lambdas with captures
    public fun nested_lambda(x: u8, y: u8): u8 {
        let add = 2u8;
        let f: |()| u8 has copy+drop = || {
            let g: |()| u8 has copy+drop = || { x + add };
            g() + y
        };
        f()
    }

    // Runner function to exercise the above features
    public fun runner(): u8 {
        let sum = sum_identity(10u16, 20u16);
        let a = add_u8(3u8, 4u8);
        let b = lambda_empty_capture(7u8);
        let c = lambda_with_capture(8u8);
        let d = nested_lambda(1u8, 2u8);
        // Sum up all results converted to u8 (sum_identity returns u16, so truncate)
        (a + b + c + d) + (sum as u8)
    }
}

//# run 0xCAFE::InlineAndLambda::add_u8 --args 1u8 2u8

//# run 0xCAFE::InlineAndLambda::add_u16 --args 11u16 22u16

//# run 0xCAFE::InlineAndLambda::sum_identity --args 7u16 8u16

//# run 0xCAFE::InlineAndLambda::lambda_empty_capture --args 10u8

//# run 0xCAFE::InlineAndLambda::lambda_with_capture --args 12u8

//# run 0xCAFE::InlineAndLambda::nested_lambda --args 3u8 4u8

//# run 0xCAFE::InlineAndLambda::runner