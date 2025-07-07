
//# publish
module 0xCAFE::LambdaAddition {
    // use an inline function to add two u8 then add 1
    public inline fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    public fun call_lambda_addition(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(a, b);
        result
    }

    public fun call_inline_function_nested(a: u8, b: u8): u8 {
        let inner_sum = add_and_increment(a, b); // should be a + b + 1
        add_and_increment(inner_sum, b) // (a + b + 1) + b + 1 = a + 2b + 2
    }

    public fun use_hex_string() {
        let hex_str: vector<u8> = x"cafebabe";
        let _first_byte = *std::vector::borrow(&hex_str, 0);
        let _second_byte = *std::vector::borrow(&hex_str, 1);

        // Do a trivial loop with hex data
        let sum: u64 = 0;
        let len = std::vector::length(&hex_str);
        let i = 0;
        while (i < len) {
            let b = *std::vector::borrow(&hex_str, i);
            sum = sum + (b as u64);
            i = i + 1;
        };
    }
}



//# run 0xCAFE::LambdaAddition::call_lambda_addition --args 5u8 7u8



//# run 0xCAFE::LambdaAddition::call_inline_function_nested --args 3u8 4u8



//# run 0xCAFE::LambdaAddition::use_hex_string
