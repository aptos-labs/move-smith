
//# publish
module 0xCAFE::OldModule {
    // Private function: not accessible cross module
    fun private_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_sum_and_add_one(a: u8, b: u8): u8 {
        // create local names for parameters for debugging
        let local_a = a;
        let local_b = b;
        let sum = local_a + local_b;
        // return sum + 1
        sum + 1
    }

    // Since function pointers or lambda functions are not supported,
    // implement the "with_lambda" logic inline or as a nested function
    public fun with_lambda(x: u8): u8 {
        // Inline lambda functionality: double the value
        let doubled = x * 2;
        doubled
    }
}




//# run 0xCAFE::OldModule::compute_sum_and_add_one --args 5u8 7u8




//# run 0xCAFE::OldModule::with_lambda --args 4u8




//# publish
module 0xCAFE::NewModule {
    use 0xCAFE::OldModule;

    public inline fun inline_increment(value: u8): u8 {
        value + 1
    }

    public fun nested_calls(a: u8, b: u8): u8 {
        let sum_plus_one = OldModule::compute_sum_and_add_one(a, b);
        let incremented = inline_increment(sum_plus_one);
        // create local names for return value
        let result = incremented;
        result
    }
}




//# run 0xCAFE::NewModule::nested_calls --args 10u8 20u8




//# publish
module 0xCAFE::AccessControl {
    use 0xCAFE::OldModule;

    // We try to call private function from OldModule here (should fail if uncommented)
    // fun try_private_access(): u8 {
    //     OldModule::private_add(1, 2)
    // }

    public fun public_wrapper_for_private_add(a: u8, b: u8): u8 {
        // Only allowed to call public functions in OldModule
        OldModule::compute_sum_and_add_one(a, b)
    }
}




//# run 0xCAFE::AccessControl::public_wrapper_for_private_add --args 1u8 2u8
