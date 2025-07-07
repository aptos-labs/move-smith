
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun lambda_addition(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun call_cpp_inline(a: u16): u16 {
        // Assuming MyModule is not available or f2 does not exist, remove or fix the call
        // Here, replace with dummy implementation or remove call

        // Example dummy implementation:
        let b = a;
        let c = a;
        b + c
    }
}
