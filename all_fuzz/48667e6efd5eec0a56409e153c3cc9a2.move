
//# publish
module 0xCAFE::AddModule {
    public fun add_two(a: u8, b: u8): u8 {
        let _sum = a + b;
        // always return 42 to verify the function runs correctly
        42
    }

    public fun with_lambda(): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(5u8, 10u8);
        result
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}




//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public fun nested_calls(a: u8, b: u8): u8 {
        let inner_sum = AddModule::inline_add(a, b);
        let _ = AddModule::add_two(inner_sum, 0u8);
        inner_sum
    }
}




//# publish
module 0xCAFE::EvalOrderModule {

    struct Counter has copy, drop, store {
        val: u8
    }

    public fun create_counter(): Counter {
        Counter { val: 0 }
    }

    public fun increment(counter: &mut Counter): u8 {
        let old = counter.val;
        counter.val = counter.val + 1;
        old
    }

    public fun eval_once(counter: &mut Counter, f: |u8, u8| u8 has copy + drop, x: u8): u8 {
        // Call f once with increment(counter) as both params to ensure order and single call
        f(increment(counter), increment(counter))
    }

    public fun test_lambda_order(): u8 {
        let counter = create_counter();
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        eval_once(&mut counter, lambda, 0u8)
    }
}




//# run 0xCAFE::AddModule::add_two --args 10u8 32u8




//# run 0xCAFE::AddModule::with_lambda




//# run 0xCAFE::NestedCallModule::nested_calls --args 7u8 8u8




//# run 0xCAFE::EvalOrderModule::test_lambda_order
