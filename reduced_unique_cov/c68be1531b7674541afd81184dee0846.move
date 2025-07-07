
//# publish
module 0xCAFE::FuncAdd {
    public fun add_two_values(a: u8, b: u8): u8 {
        let c = a + b;
        if (c > 100) {
            42u8
        } else {
            c
        }
    }

    public fun lambda_example(): u8 {
        let my_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            // returns the product for testing
            x * y
        };
        my_lambda(6u8, 7u8)
    }

    public fun nested_lambda_caller(x: u8): u8 {
        let inner_lambda: |u8| u8 has copy+drop = |v: u8| {
            v + 1u8
        };
        inner_lambda(x)
    }

    public fun lambda_returning_tuple(): (u8, u8) {
        let lambda_t: |u8, u8| (u8, u8) has copy+drop = |p: u8, q: u8| {
            (p + q, p * q)
        };
        lambda_t(3u8, 4u8)
    }
}



//# run 0xCAFE::FuncAdd::add_two_values --args 40u8 10u8



//# run 0xCAFE::FuncAdd::lambda_example



//# run 0xCAFE::FuncAdd::nested_lambda_caller --args 9u8



//# run 0xCAFE::FuncAdd::lambda_returning_tuple



//# publish
module 0xCAFE::VarBindings {
    struct Pair has copy, drop, store {
        first: u8,
        second: u8,
    }

    public fun unpack_with_parentheses(): Pair {
        let (a, b) = (5u8, 10u8);
        Pair {first: a, second: b}
    }

    public fun unpack_with_braces(): Pair {
        // Move does not support unpacking with braces in let binding,
        // so we assign directly here
        let x = 15u8;
        let y = 20u8;
        Pair {first: x, second: y}
    }
}



//# run 0xCAFE::VarBindings::unpack_with_parentheses



//# run 0xCAFE::VarBindings::unpack_with_braces



//# publish
module 0xCAFE::StructInitBlock {
    struct Computed has copy, drop, store {
        sum: u8,
        diff: u8,
    }

    public fun init_with_block(a: u8, b: u8): Computed {
        let s;
        let d;
        {
            s = a + b;
            d = if (a > b) { a - b } else { b - a };
        };
        Computed { sum: s, diff: d }
    }
}



//# run 0xCAFE::StructInitBlock::init_with_block --args 15u8 7u8 



//# publish
module 0xCAFE::SelfModule {
    struct MyCounter has copy, drop, store {
        val: u8,
    }

    public fun new_counter(init_val: u8): MyCounter {
        Self::MyCounter { val: init_val }
    }

    public fun increment(c: &mut MyCounter): u8 {
        c.val = c.val + 1;
        c.val
    }

    public fun create_and_inc(init_val: u8): u8 {
        let counter = Self::new_counter(init_val);
        Self::increment(&mut counter)
    }
}



//# run 0xCAFE::SelfModule::create_and_inc --args 9u8



//# publish
module 0xCAFE::CrossCaller {
    use 0xCAFE::FuncAdd;

    public fun call_inline_f2(a: u8, b: u8): (u64, u64) {
        let (x, _y) = (FuncAdd::add_two_values(a, b), 0u8);
        // call FuncAdd::lambda_returning_tuple for demonstration
        let (_p, _q) = FuncAdd::lambda_returning_tuple();
        // returns an inline tuple from here (faking inline function call inside)
        (u64::from(x) + 1, 100u64)
    }
}



//# run 0xCAFE::CrossCaller::call_inline_f2 --args 3u8 4u8
