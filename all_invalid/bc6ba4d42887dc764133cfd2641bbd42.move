
//# publish
module 0xCAFE::Transformers {
    use std::vector;

    public fun exp_(value: u64): u64 {
        value + 1
    }

    // Correct syntax for generic type parameter with ability bounds: `<V: vector<u64>>`
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
    // Remove 'public' from constant, as constants cannot be public
    const BASE_NUMBER: u64 = 42;

    public fun get_base(): u64 {
        BASE_NUMBER
    }
}



//# run 0xCAFE::HelperModules::get_base