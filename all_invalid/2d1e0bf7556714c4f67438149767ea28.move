
//# publish
module 0xCAFE::AddAndLambda {
    // Removed 'use 0xCAFE::MyModule;' because the module does not exist.

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10u8 as a fixed offset for testing
        sum + 10u8
    }

    public fun lambda_test(x: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        add_lambda(x, 5u8)
    }

    // Since MyModule does not exist, we have to rewrite 'nested_inline_calls'
    // Here, I provide an inline impl of f2 and f3 to simulate the functionality.
    public struct S {
        x: u32,
        y: u32,
    }

    native public fun f2(x: u16): (u32, u32); // removed, we implement inline below

    public fun f2(x: u16): (u32, u32) {
        // example function: return (x as u32, x as u32 * 2)
        (x as u32, (x as u32) * 2)
    }

    public fun f3(a: u32): S {
        // example function: return S { x: a, y: a + 1 }
        S { x: a, y: a + 1 }
    }

    public fun nested_inline_calls(x: u16): u32 {
        let (a, b) = f2(x);
        let s = f3(a);
        s.x + s.y // combine fields for test output
    }
}



//# run 0xCAFE::AddAndLambda::add_two_u8 --args 20u8 22u8



//# run 0xCAFE::AddAndLambda::lambda_test --args 15u8



//# run 0xCAFE::AddAndLambda::nested_inline_calls --args 5u16
