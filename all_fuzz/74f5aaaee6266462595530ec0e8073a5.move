
//# publish
module 0xCAFE::Arithmetic {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            7u8
        }
    }

    public fun lambdas_usage(a: u8, b: u8): u8 {
        let add = |x: u8, y: u8| { x + y };
        let mul = |x: u8, y: u8| { x * y };
        let sum = add(a, b);
        let product = mul(a, b);
        sum + product
    }
}



//# run 0xCAFE::Arithmetic::add_and_return_fixed --args 3u8 4u8



//# run 0xCAFE::Arithmetic::lambdas_usage --args 2u8 5u8



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Arithmetic;

    public inline fun inline_increment(x: u8): u8 {
        // Removed invalid tuple unpacking from single return value
        let result = Arithmetic::add_and_return_fixed(x, 1u8);
        result
    }

    public fun call_nested_functions(x: u8): u8 {
        let y = inline_increment(x);
        let z = Arithmetic::add_and_return_fixed(y, 3u8);
        z
    }

    public fun sequence_instructions(x: u8): u8 {
        let a = x;
        a = a + 1;
        a = a * 2;
        if (a > 10) {
            a = 10;
        } else {
            a = a - 1;
        };
        a
    }
}



//# run 0xCAFE::Caller::call_nested_functions --args 5u8



//# run 0xCAFE::Caller::sequence_instructions --args 4u8



//# publish
module 0xCAFE::Accumulator {
    public fun inc(x: &mut u8) {
        *x = *x + 1;
    }

    public fun accumulate_sequentially(): u8 {
        let value = 0u8;
        inc(&mut value);
        inc(&mut value);
        inc(&mut value);
        value
    }

    public fun nested_accumulate(): u8 {
        let value = 1u8;

        // Local functions not supported, moving helper to a private function outside, or inline here:
        {
            inc(&mut value);
            inc(&mut value);
        };

        inc(&mut value);
        value
    }
}



//# run 0xCAFE::Accumulator::accumulate_sequentially



//# run 0xCAFE::Accumulator::nested_accumulate
