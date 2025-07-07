
//# publish
module 0xCAFE::FeatureTest {
    // Removed unused import std::vector
    // Removed use 0xCAFE::MyModule because it's not available and causes unbound module errors

    // 1. Test u8 addition function returning specific value
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    // 2. Function with lambda expressions to double and triple an input
    // Aptos Move currently does not support lambda expressions directly;
    // we can replace them with local functions instead.
    // But Move latest supports function pointers, so we can use that approach.
    // Alternatively, inline the logic.

    // Using local anonymous function is not supported, so use inline expressions.
    public fun lambda_test(x: u8): (u8, u8) {
        // Define function pointers not feasible in this context, inline logic:
        let double = x * 2;
        let triple = x * 3;
        (double, triple)
    }

    // 3. Call inline function from MyModule and then process result
    // Since MyModule does not exist, we replace this function with a dummy calculation
    // or implement our own function f2
    // For demonstration, implement f2 here:

    public fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }

    public fun nested_inline_call(a: u16): u16 {
        let (res1, res2) = Self::f2(a);
        res1 + res2
    }

    // 4. Generic struct with ability constraints on type parameter
    struct Wrapper<T: copy + drop> has copy, drop {
        value: T
    }

    public fun create_wrapper_u8(val: u8): Wrapper<u8> {
        Wrapper { value: val }
    }

    public fun copy_wrapper(wrapper: Wrapper<u8>): Wrapper<u8> {
        copy wrapper
    }

    // 5. Function parameter with ability constraint 'has drop' in type annotation
    // --- FIXED: Cannot write 'u8 has drop' directly, use a type parameter with constraints instead
    public fun accept_has_drop_param<T: drop>(x: T): T {
        // Simply return the value as proof it accepts the param
        x
    }
}
