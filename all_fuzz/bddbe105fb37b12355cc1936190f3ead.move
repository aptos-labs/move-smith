
//# publish
module 0xCAFE::LambdaAndInline {
    // Test lambda expressions and inline function calls

    struct Counter has copy, drop, store {
        count: u64,
    }

    const MAX_COUNT: u64 = 100;

    struct Config has store {
        invariant_enabled: bool,
    }

    public inline fun inline_increment(a: u64): u64 {
        a + 1
    }

    public fun apply_lambda_to_u64(x: u64): u64 {
        let double_lambda: |u64|u64 has copy + drop = |a: u64| {
            a * 2
        };
        double_lambda(x)
    }

    public fun increment_counter(counter: &mut Counter) {
        let new_count = inline_increment(counter.count);
        assert!(new_count <= MAX_COUNT, 777);
        counter.count = new_count;
    }

    public fun new_counter(): Counter {
        Counter { count: 0 }
    }

    public fun init_config(): Config {
        Config { invariant_enabled: true }
    }

    // Added a public accessor for count so other modules can read it safely
    public fun get_count(counter: &Counter): u64 {
        counter.count
    }
}




//# run 0xCAFE::LambdaAndInline::apply_lambda_to_u64 --args 21u64




//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaAndInline;

    struct WrappedCounter has copy, drop, store {
        inner: LambdaAndInline::Counter,
    }

    public fun call_nested_increment(counter: &mut LambdaAndInline::Counter) {
        LambdaAndInline::increment_counter(counter);
    }

    public fun run_test(): u64 {
        let c = LambdaAndInline::new_counter();
        call_nested_increment(&mut c);
        call_nested_increment(&mut c);
        // Use accessor to get count value
        let count = LambdaAndInline::get_count(&c);
        let doubled = LambdaAndInline::apply_lambda_to_u64(count);
        doubled
    }
}




//# run 0xCAFE::CallerModule::run_test
