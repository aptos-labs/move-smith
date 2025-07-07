
//# publish
module 0xCAFE::FeatureTest {
    // Removed unused alias 'std::signer'

    struct Wrapper has copy, drop, store {
        value: u64,
    }

    // 1. Function that adds two u8 values and returns x + y + 1u8
    public fun add_then_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    // 2. Function with lambdas: Move does not support lambda expressions;
    // Instead, define inline functions.
    fun add(x: u8, y: u8): u8 {
        x + y
    }

    fun multiply(x: u8, y: u8): u8 {
        x * y
    }

    public fun lambda_usage(a: u8, b: u8): u8 {
        let sum = add(a, b);
        let product = multiply(a, b);
        sum + product // returns (a+b) + (a*b)
    }

    // 3. Call inline function from MyModule::f2, sum the tuple values, returns u16
    // Provide the missing MyModule::f2 function inline here
    public fun call_my_module_inline(a: u16): u16 {
        let (v1, v2) = Self::f2(a);
        v1 + v2
    }

    /// Inline function f2 returns a tuple (u16, u16)
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    // 4a. Compare two u64 values for equality
    public fun equals_u64(val1: u64, val2: u64): bool {
        val1 == val2
    }

    // 4b. Compare two Wrapper structs (just the value field) for equality
    public fun equals_wrapper(w1: &Wrapper, w2: &Wrapper): bool {
        w1.value == w2.value
    }

    // Helper function to create Wrapper struct
    public fun create_wrapper(val: u64): Wrapper {
        Wrapper { value: val }
    }

    // Runner function that exercises all above functions
    public fun run() {
        let _ = add_then_increment(10u8, 5u8);

        let _ = lambda_usage(3u8, 4u8);

        let _ = call_my_module_inline(7u16);

        let eq1 = equals_u64(100u64, 100u64);
        let eq2 = equals_u64(100u64, 101u64);

        let w1 = create_wrapper(42u64);
        let w2 = create_wrapper(42u64);
        let w3 = create_wrapper(43u64);

        let eq_w1_w2 = equals_wrapper(&w1, &w2);
        let eq_w1_w3 = equals_wrapper(&w1, &w3);

        // Silence unused variable warnings by binding but not doing anything with them
        let _ = eq1;
        let _ = eq2;
        let _ = eq_w1_w2;
        let _ = eq_w1_w3;
    }
}
