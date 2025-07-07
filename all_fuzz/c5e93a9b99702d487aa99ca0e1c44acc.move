
//# publish
module 0xCAFE::InlineModule {
    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_double(x: u8): u8 {
        let double_fn: |u8|u8 has copy+drop = |val: u8| {
            val * 2
        };
        double_fn(x)
    }

    public fun call_inline_sum(a: u8, b: u8): u8 {
        let result = 0xCAFE::InlineModule::inline_add(a, b);
        result
    }
}


//# publish
module 0xCAFE::ExpTransformModule {
    use std::vector;

    struct Exp has copy, drop, store {
        val: u8,
    }

    struct Context has store {}

    public fun exp_(_ctx: &Context, exp: &Exp): Exp {
        // Just a dummy transform: add 1 to exp.val
        let new_val = exp.val + 1;
        Exp { val: new_val }
    }

    public fun exps(ctx: &Context, exps_list: vector<Exp>): vector<Exp> {
        let result = vector::empty<Exp>();
        let len = vector::length(&exps_list);
        let i = 0;
        while (i < len) {
            let exp_ref = vector::borrow(&exps_list, i);
            let transformed = exp_(ctx, exp_ref);
            vector::push_back(&mut result, transformed);
            i = i + 1;
        };
        // explicitly consume ctx to fix drop error
        let Context { } = *ctx;
        result
    }

    public fun run_example(): vector<Exp> {
        let ctx = Context {};
        let exp1 = Exp { val: 1 };
        let exp2 = Exp { val: 2 };
        let exp3 = Exp { val: 3 };
        let list = vector[exp1, exp2, exp3];
        exps(&ctx, list)
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_sum --args 10u8 20u8



//# run 0xCAFE::AdditionModule::lambda_double --args 21u8



//# run 0xCAFE::AdditionModule::call_inline_sum --args 7u8 8u8



//# run 0xCAFE::ExpTransformModule::run_example
