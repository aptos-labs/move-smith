
//# publish
module 0xCAFE::Computation {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // return specific value 42 if sum == 42 otherwise sum
        if (sum == 42) {
            42
        } else {
            sum
        }
    }

    public fun test_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let add = a + b;
            let mul = a * b;
            (add, mul)
        };
        lambda(x, y)
    }

    public inline fun twice(x: u8): u8 {
        x * 2
    }
}



//# run 0xCAFE::Computation::add_two_values --args 20u8 22u8



//# run 0xCAFE::Computation::add_two_values --args 10u8 15u8



//# run 0xCAFE::Computation::test_lambda --args 5u8 6u8



//# publish
module 0xCAFE::NestedUsage {
    use 0xCAFE::Computation;

    public fun nested_calls(x: u8): u8 {
        Computation::twice(x) + 1
    }

    public fun mutate_in_nested_block(x: u8): u8 {
        let outer = x;
        {
            let inner = 5;
            outer = outer + inner;
        };
        outer
    }
}



//# run 0xCAFE::NestedUsage::nested_calls --args 7u8



//# run 0xCAFE::NestedUsage::mutate_in_nested_block --args 10u8



//# publish
module 0xCAFE::BinaryCheck {
    use std::vector;

    const MODULE_MAGIC: u32 = 0xCAFE;

    public fun check_magic_in(bytes: vector<u8>): bool {
        // Check if bytes at start represent MODULE_MAGIC
        // MODULE_MAGIC = 0xCAFE = 51966 decimal
        if (vector::length(&bytes) < 2) {
            false
        } else {
            let first = *vector::borrow(&bytes, 0);
            let second = *vector::borrow(&bytes, 1);
            // Note: 0xCAFE in big-endian is [0xCA, 0xFE]
            (first == 0xCA) && (second == 0xFE)
        }
    }
}



//# run 0xCAFE::BinaryCheck::check_magic_in --args x"CAFE0000"
