
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_and_return_special_value(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            100u8
        } else {
            50u8
        }
    }

    public fun test_lambda_input(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| { v * 2 };
        lambda(x)
    }

    public fun test_multiple_mut_borrows(): u8 {
        let x = 1u8;
        x = x + 1;
        x = x + 2;
        x
    }

    struct Point has store {
        x: u8,
        y: u8,
    }

    public fun create_point(x: u8, y: u8): Point {
        Point { x, y }
    }

    fun private_function(): u8 {
        99u8
    }

    friend fun friend_function(): u8 {
        77u8
    }
}



//# run 0xCAFE::ComputeAdd::add_and_return_special_value --args 6u8 5u8



//# run 0xCAFE::ComputeAdd::test_lambda_input --args 8u8



//# run 0xCAFE::ComputeAdd::test_multiple_mut_borrows



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::ComputeAdd;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let sum = inline_add(a, b);
        let doubled = ComputeAdd::test_lambda_input(sum);
        doubled
    }
}



//# run 0xCAFE::NestedCalls::call_inline_and_lambda --args 3u8 4u8
