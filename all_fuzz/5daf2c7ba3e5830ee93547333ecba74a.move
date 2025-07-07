
//# publish
module 0xCAFE::Arithmetic {
    public fun add_u8_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}




//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Arithmetic;

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let incremented = Arithmetic::inline_increment(x);
        let result = incremented + y;
        result
    }
}




//# publish
module 0xCAFE::Expressions {
    public fun unary_binary_mix(x: u8, y: u8): u8 {
        // Since Move doesn't support unary minus or wrapping_sub on u8,
        // simulate negation on u8 by doing 0 - v using checked arithmetic:
        // But subtracting larger from smaller results in abort.
        // Instead, use modulo arithmetic emulation by casting to i8 or restructure the formula.

        // We cannot cast in Move, so rewrite expression arithmetically:
        // Original: -(-(x + y) + y) + x
        // We'll expand step by step:
        //
        // Let s = x + y
        // neg(s) = 0u8 - s -> underflow abort possible
        //
        // To avoid abort, we can refactor expression:
        //
        // Let's rewrite the original expression mathematically:
        // expr = - ( - (x + y) + y ) + x
        // expr = - ( -s + y ) + x
        // expr = - ( -s + y ) + x
        // Note that -s + y = y - s
        // So expr = - (y - s) + x = s - y + x = (x + y) - y + x = x + x = 2 * x
        //
        // So the whole complicated expression simplifies to 2*x

        let expression_result = x + x;
        expression_result
    }
}




//# publish
module 0xCAFE::AddressLiterals {
    // Removed unused import 'vector'
    public fun get_addresses(): (address, address, vector<address>) {
        let addr1 = @0xCAFE;
        let addr2 = @0xBEEF;
        let addresses = vector[@0xCAFE, @0xBEEF, @0xDABB];
        (addr1, addr2, addresses)
    }
}




//# run 0xCAFE::Arithmetic::add_u8_and_return_sum --args 7u8 8u8




//# run 0xCAFE::NestedCalls::call_inline_and_add --args 5u8 6u8




//# run 0xCAFE::Expressions::unary_binary_mix --args 10u8 3u8




//# run 0xCAFE::AddressLiterals::get_addresses
