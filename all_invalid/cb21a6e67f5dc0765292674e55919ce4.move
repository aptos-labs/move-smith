
//# publish
module 0xCAFE::Transformers {
    use std::vector;

    public fun exp_(value: u64): u64 {
        value + 1
    }

    public fun exps<V: vector<u64>>(values: V): vector<u64> {
        let results = vector::empty<u64>();
        let len = vector::length(&values);
        let i = 0;
        while (i < len) {
            let val = vector::borrow(&values, i);
            vector::push_back(&mut results, exp_(*val));
            i = i + 1;
        }
        results
    }

    public fun run_example() {
        let vals = vector::empty<u64>();
        vector::push_back(&mut vals, 10);
        vector::push_back(&mut vals, 20);
        vector::push_back(&mut vals, 30);
        let transformed = exps(vals);
        // Do nothing, just to exercise code
        let _ = transformed;
    }
}


//# run 0xCAFE::Transformers::run_example



//# publish
module 0xCAFE::HelperModules {
    // Define a simple non-cyclic helper module for constants
    public const BASE_NUMBER: u64 = 42;

    public fun get_base(): u64 {
        BASE_NUMBER
    }
}


//# run 0xCAFE::HelperModules::get_base


// Featurres:
// e4f4fb756ae16b178004ed92b279c472: Use the 'exps' function to transform a list of Move expressions into another form, applying the 'exp_' function to each expression within a compiler context.
// 322a88b49cb3bc03a2c0848b4e7784c8: Design modules to avoid cyclic dependencies to prevent dependency cycle errors.
// 582ce7e20d31ee15d43990e650dc3397: Define functions with one or more parameters and a return type
