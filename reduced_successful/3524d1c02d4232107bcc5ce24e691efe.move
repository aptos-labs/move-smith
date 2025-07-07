
//# publish
module 0xCAFE::MyModule {
    /// Inline function f2 that takes a u16 and returns a tuple of two u16 numbers.
    public inline fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }
}


//# publish
module 0xCAFE::Arithmetic {
    /// Adds two u8 numbers and returns u8 result incremented by 5.
    public fun add_and_inc(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    /// Demonstrates lambda expressions that add and multiply two u8 numbers.
    public fun lambda_demo(x: u8, y: u8): (u8, u8) {
        let add = |a: u8, b: u8| { a + b };
        let mul = |a: u8, b: u8| { a * b };
        (add(x, y), mul(x, y))
    }

    /// Calls the inline function f2 from module MyModule and sums the returned tuple elements,
    /// then returns the sum as u32.
    public fun call_inline_and_sum(a: u16): u32 {
        let (p, q) = 0xCAFE::MyModule::f2(a);
        (p + q) as u32
    }
}



//# publish
module 0xCAFE::AliasTest {
    use 0xCAFE::Arithmetic as Arith;

    /// Reference current module's resource name by direct name (imaginary resource for demo).
    /// Using a dummy struct and dummy function to demonstrate usage.
    struct DummyResource has store, key {}

    /// Returns a fixed number.
    public fun get_fixed(): u8 {
        42
    }

    /// Calls add_and_inc from Arithmetic via alias Arith.
    public fun alias_call_add(a: u8, b: u8): u8 {
        Arith::add_and_inc(a, b)
    }
}



//# run 0xCAFE::Arithmetic::add_and_inc --args 2u8 3u8



//# run 0xCAFE::Arithmetic::lambda_demo --args 4u8 5u8



//# run 0xCAFE::Arithmetic::call_inline_and_sum --args 7u16



//# run 0xCAFE::AliasTest::get_fixed



//# run 0xCAFE::AliasTest::alias_call_add --args 10u8 15u8
