
//# publish
module 0xCAFE::AddModule {
    // Module purely to test u8 addition return value

    public fun add_and_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ignore = sum; // We use sum to demonstrate simple arithmetic 
        42u8
    }
}



//# run 0xCAFE::AddModule::add_and_return_42 --args 10u8 32u8




//# publish
module 0xCAFE::LambdaModule {
    // Module to test lambda expressions and usage

    public fun run_lambda_add(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun apply_lambda_to_value(f: |u8| u8, val: u8): u8 {
        f(val)
    }
}



//# run 0xCAFE::LambdaModule::run_lambda_add --args 7u8 5u8




//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::LambdaModule;

    public inline fun inline_increment(v: u8): u8 {
        v + 1
    }

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        // Call inline function first
        let inc = inline_increment(x);

        // Create lambda to add y
        let add_y_lambda: |u8| u8 has copy+drop = |a: u8| a + y;

        // Apply lambda to inc
        LambdaModule::apply_lambda_to_value(add_y_lambda, inc)
    }
}



//# run 0xCAFE::InlineCallModule::call_inline_and_lambda --args 10u8 5u8




//# publish
module 0xCAFE::AbilityConstraints {
    // Struct with ability constraints on generic type T

    struct Container<T: copy + drop + store + key> has store, key {
        value: T
    }

    public fun create_container<T: copy + drop + store + key>(v: T): Container<T> {
        Container<T> {value: v}
    }

    public fun get_value<T: copy + drop + store + key>(c: &Container<T>): &T {
        &c.value
    }
}



//# run 0xCAFE::AbilityConstraints::create_container --args 123u8 --type-args u8
