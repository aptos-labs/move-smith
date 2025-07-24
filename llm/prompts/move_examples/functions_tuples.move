//# publish
module 0xCAFE::FunctionsTuples {
    // An inline function that returns a tuple
    public inline fun return_tuple(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }

    public fun higher_order_function(x: |u8|u8, y: u8): u8 {
        x(y)
    }
}
