
//# publish
module 0xCAFE::Adder {
    public fun add_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 1 to ensure addition is done before returning
        sum + 1
    }

    public fun lambda_example(): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(5u8, 6u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun test_inline_add(): u8 {
        inline_add(10u8, 20u8)
    }

    public fun with_lambda_arg(f: |u8|u8, x: u8): u8 {
        f(x)
    }

    // Wrapper function providing the lambda internally
    public fun run_with_lambda_arg(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |y: u8| y + 1;
        with_lambda_arg(lambda, x)
    }

    public fun test_reassign() {
        let x = 10u8;
        let (a, b) = (x, x + 1);
        let s = StructWithReassign {f1: a, f2: b};

        // Reassign inside destructuring
        let a = s.f1;
        let b = s.f2;
        let a = a;
        a = a + 5;
        let _s2 = StructWithReassign {f1: a, f2: b};
    }

    struct StructWithReassign has copy, drop {
        f1: u8,
        f2: u8,
    }
}




//# run 0xCAFE::Adder::add_values --args 3u8 4u8




//# run 0xCAFE::Adder::lambda_example




//# run 0xCAFE::Adder::test_inline_add




//# run 0xCAFE::Adder::run_with_lambda_arg --args 7u8




//# run 0xCAFE::Adder::test_reassign
