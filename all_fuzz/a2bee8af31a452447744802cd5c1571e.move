
//# publish
module 0xCAFE::AdditionModule {
    // Module to test addition and inline function calls
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_and_return_fixed(a: u8, b: u8): u8 {
        // Compute sum of a and b before returning 42
        let _sum = add_u8(a, b);
        42u8
    }
}



//# run 0xCAFE::AdditionModule::compute_and_return_fixed --args 10u8 15u8



//# publish
module 0xCAFE::LambdaModule {
    // Module to test lambdas functionality
    public fun sum_lambda(): u8 {
        let add: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        add(20u8, 22u8)
    }

    public fun nested_lambda(): u8 {
        let outer: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            let inner: |u8| u8 has copy + drop = |x: u8| {
                x + 5u8
            };
            let sum = a + b;
            inner(sum)
        };
        outer(7u8, 8u8)
    }
}



//# run 0xCAFE::LambdaModule::sum_lambda



//# run 0xCAFE::LambdaModule::nested_lambda



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun nested_add_call(a: u8, b: u8): u8 {
        // Calls add_u8 inline function inside AdditionModule twice
        let first = AdditionModule::add_u8(a, b);
        let second = AdditionModule::add_u8(first, 10u8);
        second
    }
}



//# run 0xCAFE::NestedCallModule::nested_add_call --args 3u8 4u8



//# publish
module 0xCAFE::TupleEvalOrder {
    use std::debug;

    const SEQUENCE: u8 = 0;

    // Since Move does not support mutable static variables, 
    // use a global resource to simulate mutation for testing side effects.
    // Define a resource to hold counter:
    struct Counter { val: u8 }

    public fun init_counter(account: &signer) {
        move_to<Counter>(account, Counter { val: 0 });
    }

    public fun side_effect_increment(account: &signer): u8 acquires Counter {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        let current = counter.val;
        counter.val = current + 1;
        current
    }

    public fun test_tuple_order(account: &signer): (u8, u8, u8) acquires Counter {
        // The tuple assignment forces evaluation order from left to right.
        let (a, b, c) = (
            side_effect_increment(account),
            side_effect_increment(account),
            side_effect_increment(account)
        );
        (a, b, c)
    }
}



//# run 0xCAFE::TupleEvalOrder::init_counter --args signer:0xCAFE


//# run 0xCAFE::TupleEvalOrder::test_tuple_order --args signer:0xCAFE

